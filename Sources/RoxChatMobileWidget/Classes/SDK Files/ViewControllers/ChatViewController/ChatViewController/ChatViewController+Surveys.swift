//
//  ChatViewController+SurveyListener.swift
//  RoxchatClientLibrary_Example
//
//  Copyright © 2021 Roxchat. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import RoxchatClientLibrary

// MARK: - ROXCHAT: SurveyListener
extension ChatViewController: SurveyListener {
    
    func on(survey: Survey) {
        surveyCounter = 0
        for form in survey.getConfig().getDescriptor().getForms() {
            surveyCounter += form.getQuestions().count
        }
    }
    
    func on(nextQuestion: SurveyQuestion) {
        DispatchQueue.main.async {
            if self.rateStarsViewController != nil {
                self.delayedSurvayQuestion = nextQuestion
                return
            }
            self.delayedSurvayQuestion = nil
            self.surveyCounter -= 1
            let description = nextQuestion.getText()
            
            let operatorId = ""
            switch nextQuestion.getType() {
            case .comment:
                self.showSurveyCommentDialog(description: description)
            case .radio:
                self.showSurveyRadioButtonDialog(description: description, points: nextQuestion.getOptions() ?? [])
            case .stars:
                self.showRateStars(operatorId: operatorId, isSurvey: true, description: description)
            }
        }
    }
    
    func onSurveyCancelled() {
        surveyCounter = -1
        self.surveyCommentViewController?.close(nil)
        self.rateStarsViewController?.close(nil)
        self.surveyRadioButtonViewController?.close(nil)
        
        self.rateStarsViewController = nil
        self.surveyRadioButtonViewController = nil
        self.surveyCommentViewController = nil
        
        self.delayedSurvayQuestion = nil
    }
}

// MARK: - ROXCHAT: Survey
extension ChatViewController {
    
    func showRateOperatorDialog(operatorId: String?) {
        if let operatorId = operatorId {
            self.showRateStars(operatorId: operatorId, isSurvey: false, description: "")
        }
    }
    
    func showRateOperatorDialog() {
        showRateOperatorDialog(operatorId: currentOperatorId())
    }
    
    func currentOperatorId() -> String? {
        if let operatorId = RoxchatServiceController.currentSession.getCurrentOperator()?.getID() {
            return operatorId
        }
        
        for message in chatMessages.reversed() {
            if let operatorId = message.getOperatorID() {
                return operatorId
            }
        }
        return nil
    }

    func isCurrentOperatorRated() -> Bool? {

        if let operatorId = RoxchatServiceController.currentSession.getCurrentOperator()?.getID() {
            return alreadyRatedOperators[operatorId]
        }

        for message in chatMessages.reversed() {
            if let operatorId = message.getOperatorID() {
                return alreadyRatedOperators[operatorId]
            }
        }
        return nil
    }
    
    func showRateStarsDialog(description: String) {
        
        self.showRateStars(operatorId: "", isSurvey: true, description: description)
    }
    
    private func showRateStars(operatorId: String, isSurvey: Bool, description: String) {
        DispatchQueue.main.async {
            
            let vc = RateStarsViewController.loadViewControllerFromXib()
            let chatConfig = self.chatConfig as? WMChatViewControllerConfig
            vc.delegate = self
            vc.rateOperatorDelegate = self
            vc.config = chatConfig?.surveyViewConfig
            self.rateStarsViewController = vc
            vc.operatorId = operatorId
            vc.isSurvey = isSurvey
            vc.descriptionText = description
            vc.modalPresentationStyle = .overCurrentContext
            vc.currentRating = self.alreadyRatedOperators[operatorId] != true ? 0.0 : Double(WebimServiceController.shared.currentSession().getLastRatingOfOperatorWith(id: operatorId))
            self.present(vc, animated: true) {
                UIView.animate(withDuration: 0.3) { [weak vc] in
                    vc?.view.backgroundColor = .black.withAlphaComponent(0.5)
                }
            }
        }
    }
    
    func showSurveyCommentDialog(description: String) {
        DispatchQueue.main.async {
            
            let vc = SurveyCommentViewController.loadViewControllerFromXib()
            self.surveyCommentViewController = vc
            vc.descriptionText = description
            vc.delegate = self
            vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func showSurveyRadioButtonDialog(description: String, points: [String]) {
        
        DispatchQueue.main.async {
            let vc = SurveyRadioButtonViewController.loadViewControllerFromXib()
            self.surveyRadioButtonViewController = vc
            vc.descriptionText = description
            vc.points = points
            vc.delegate = self
            vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(vc, animated: false, completion: nil)
            
        }
    }
}

extension ChatViewController: RateStarsViewControllerDelegate, WMSurveyViewControllerDelegate {
    func rateOperator(operatorID: String, rating: Int) {
        RoxchatServiceController.currentSession.rateOperator(
            withID: operatorID,
            byRating: rating,
            completionHandler: self
        )
    }
    
    @objc
    func sendSurveyAnswer(_ surveyAnswer: String) {
        RoxchatServiceController.currentSession.send(
            surveyAnswer: surveyAnswer,
            completionHandler: self
        )
    }
    
    func surveyViewControllerClosed() {
        self.rateStarsViewController = nil
        if let delayedQuestion = self.delayedSurvayQuestion {
            self.on(nextQuestion: delayedQuestion)
        }
    }
}

// MARK: - ROXCHAT: CompletionHandlers
extension ChatViewController: RateOperatorCompletionHandler, SendSurveyAnswerCompletionHandler {
    
    func onSuccess() {
        if self.delayedSurvayQuestion == nil || self.surveyCounter == 0 {
            self.thanksView.showAlert()
            if surveyCounter == 0 {
                surveyCounter = -1
            }
            guard let currentOperator = RoxchatServiceController.currentSession.getCurrentOperator() else {
                return
            }
            let sessionState = WebimServiceController.currentSession.sessionState()
            
            if sessionState != .closedByOperator && sessionState != .closedByVisitor {
                alreadyRatedOperators[currentOperator.getID()] = true
            }
            changed(operator: RoxchatServiceController.currentSession.getCurrentOperator(),
                    to: RoxchatServiceController.currentSession.getCurrentOperator())
        }
    }
    
    func onFailure(error: RateOperatorError) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.41) {
            var message = String()
            switch error {
            case .noChat:
                message = "There is no current agent to rate".localized
            case .wrongOperatorId:
                message = "This agent not in the current chat".localized
            case .noteIsTooLong:
                message = "Note for rate is too long".localized
            }
            
            self.alertDialogHandler.showDialog(
                withMessage: message,
                title: "Operator rating failed".localized
            )
        }
    }
    
    // SendSurveyAnswerCompletionHandler
    func onFailure(error: SendSurveyAnswerError) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.41) {
            var message = String()
            switch error {
            case .incorrectRadioValue:
                message = "Incorrect radio value".localized
            case .incorrectStarsValue:
                message = "Incorrect stars value".localized
            case .incorrectSurveyID:
                message = "Incorrect survey ID".localized
            case .maxCommentLength_exceeded:
                message = "Comment is too long".localized
            case .noCurrentSurvey:
                message = "No current survey".localized
            case .questionNotFound:
                message = "Question not found".localized
            case .surveyDisabled:
                message = "Survey disabled".localized
            case .unknown:
                message = "Unknown error".localized
            }
            
            self.alertDialogHandler.showDialog(
                withMessage: message,
                title: "Failed to send survey answer".localized
            )
        }
    }
}
