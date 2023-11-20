//
//  ChatTestView.swift
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

import Foundation
import UIKit
import RoxchatClientLibrary

protocol ChatTestViewDelegate: UIViewController {
    func getSearchMessageText() -> String
    func showSearchResult(searcMessages: [Message]?)
    func toogleAutotest() -> Bool
    func clearHistory()
    func sendResolution(answer: Int)
    func getConfig() -> RoxchatServerSideSettingsManager?
}

class ChatTestView: UIView {
    @IBOutlet var autotestButton: UIButton!
    @IBOutlet var clearHistory: UIButton!
    @IBOutlet var operatorInfo: UIButton!
    @IBOutlet var showConfig: UIButton!
    @IBOutlet var stolotoRate: UIButton!
    
    private weak var delegate: ChatTestViewDelegate!
    private var titleViewOperatorTitle: String?
    private var titleViewOperatorInfo: String?
    
    override func loadXibViewSetup() {
        clearHistory.setImage(deleteImage, for: .normal)
    }
    
    func setupView(delegate: ChatTestViewDelegate) {
        self.delegate = delegate
    }
    
    func setupOperatorInfo(titleViewOperatorTitle: String?, titleViewOperatorInfo: String?) {
        self.titleViewOperatorInfo = titleViewOperatorInfo
        self.titleViewOperatorTitle = titleViewOperatorTitle
    }
    
    @IBAction func runAutotestClicked() {
        let autotestRunning = self.delegate.toogleAutotest()
        self.autotestButton.setTitle(autotestRunning ? "Stop autotest" : "Run autotest", for: .normal)
    }
    
    @IBAction func hideTap() {
        self.alpha = 0
    }
    
    @IBAction func searchTap() {
        let searchText = self.delegate.getSearchMessageText()
        if searchText.isEmpty {
            self.delegate.showSearchResult(searcMessages: nil)
        } else {
            RoxchatServiceController.shared.currentSession().searchMessagesBy(query: searchText, completionHandler: self)
        }
    }
    
    @IBAction func clearHistoryTap(_ sender: Any) {
        let alert = UIAlertController(title: "Очистить историю",
                                      message: "Очистка истории",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "ОК",
            style: .default,
            handler: { _ in
                RoxchatServiceController.currentSession.clearHistory()
                self.delegate.clearHistory()
            }
        )
        
        let cancelAction = UIAlertAction(
            title: "Отменить",
            style: .cancel
        )
        let actions = [okAction, cancelAction]
        actions.forEach({ alert.addAction($0) })
        self.delegate.present(alert, animated: true)
    }
    
    @IBAction func operatorInfotap(_ sender: Any) {
        let alertDialogHandler = AlertController(delegate: delegate)
        let operatorTitle = titleViewOperatorTitle ?? ""
        let operatorInfo = titleViewOperatorInfo ?? ""
        alertDialogHandler.showOperatorInfo(
            withMessage: "\("Agent title".localized): \(operatorTitle.description) \n \("Additional information".localized): \(operatorInfo.description) "
        )
    }
    
    @IBAction func showStolotoConfig(_ sender: Any) {
        guard let config = delegate.getConfig() else {
            return
        }
        
        let configString = """
        rate_form: \(config.getRateForm())
        rated_entity: \(config.getRatedEntity())
        visitor_segment: \(config.getVisitorSegment())
        """
        
        let alert = UIAlertController(title: "Настройки конфига столото",
                                      message: configString,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: "Отменить",
            style: .cancel
        )
        
        let actions = [cancelAction]
        actions.forEach({ alert.addAction($0) })
        self.delegate.present(alert, animated: true)
    }
    
    @IBAction func stolotoForm(_ sender: Any) {
        let alert = UIAlertController(title: "Решен ли вопрос?",
                                      message: "Ответ",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "Да",
            style: .default,
            handler: { _ in
                self.delegate.sendResolution(answer: 1)
            }
        )
        
        let cancelAction = UIAlertAction(
            title: "Нет",
            style: .default,
            handler: { _ in
                self.delegate.sendResolution(answer: 0)
            }
        )
        let actions = [okAction, cancelAction]
        actions.forEach({ alert.addAction($0) })
        self.delegate.present(alert, animated: true)
    }
    
}

extension ChatTestView: SearchMessagesCompletionHandler {
    
    func onSearchMessageSuccess(query: String, messages: [Message]) {
        self.delegate.showSearchResult(searcMessages: messages)
        print(messages)
    }
    
    func onSearchMessageFailure(query: String) {
        self.delegate.showSearchResult(searcMessages: [])
        print("onSearchMessageFailure")
    }
    
}
