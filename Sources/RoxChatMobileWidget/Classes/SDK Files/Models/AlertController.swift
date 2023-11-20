//
//  UIAlertHandler.swift
//  RoxchatClientLibrary_Tests
//
//  Copyright © 2018 Roxchat. All rights reserved.
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

final class CompletableAlertController: UIAlertController, Completable {
    var completionHandler: (() -> Void)?

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        completionHandler?()
    }
}

class AlertController {
    
    // MARK: - Properties
    private weak var delegate: UIViewController?
    private var alertController: CompletableAlertController!
    
    // MARK: - Initializer
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    // MARK: - Methods
    func showDialog(
        withMessage message: String,
        title: String?,
        buttonTitle: String = "OK".localized,
        buttonStyle: UIAlertAction.Style = .cancel,
        action: (() -> Void)? = nil
    ) {
        alertController = CompletableAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let alertAction = UIAlertAction(
            title: buttonTitle,
            style: buttonStyle,
            handler: { _ in
                action?()
            })
        
        alertController.addAction(alertAction)
        
        if buttonStyle != .cancel {
            let alertActionOther = UIAlertAction(
                title: "Cancel".localized,
                style: .cancel)
            alertController.addAction(alertActionOther)
        }
        
        delegate?.present(alertController, animated: true)
    }
    
    func showDepartmentListDialog(
        withDepartmentList departmentList: [Department],
        action: @escaping (String) -> Void,
        sourceView: UIView? = nil,
        cancelAction: (() -> Void)? = nil
    ) {
        alertController = CompletableAlertController(
            title: "Choose department".localized,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for department in departmentList {
            let departmentAction = UIAlertAction(
                title: department.getName(),
                style: .default,
                handler: { _ in
                    action(department.getKey())
                }
            )
            
            alertController.addAction(departmentAction)
        }
        
        let alertAction = UIAlertAction(
            title: "Cancel".localized,
            style: .cancel,
            handler: { _ in cancelAction?() })
        
        alertController.addAction(alertAction)

        // Working around iPad
        if let popoverController = alertController.popoverPresentationController {
            guard let sourceView = sourceView else {
                fatalError("No source view for presenting alert popover")
            }

            let commonInset: CGFloat = (delegate?.view.bounds.height ?? 0) / 4

            popoverController.sourceView = sourceView
            popoverController.permittedArrowDirections = .init(rawValue: 0) // Removing arrow.
            popoverController.popoverLayoutMargins = UIEdgeInsets(
                top: commonInset,
                left: .zero,
                bottom: commonInset,
                right: .zero)
        }
        
        delegate?.present(alertController, animated: true)
    }
    
    func showSendFailureDialog(
        withMessage message: String,
        title: String,
        action: (() -> Void)? = nil
    ) {
        showDialog(
            withMessage: message,
            title: title,
            buttonTitle: "OK".localized,
            action: action
        )
    }
    
    func showChatClosedDialog() {
        showDialog(
            withMessage: "Chat finished.".localized,
            title: nil,
            buttonTitle: "OK".localized
        )
    }
    
    func showCreatingSessionFailureDialog(withMessage message: String) {
        showDialog(
            withMessage: message,
            title: "Session creation failed".localized,
            buttonTitle: "OK".localized
        )
    }
    
    func showFileLoadingFailureDialog() {
        showDialog(
            withMessage: "LoadFileErrorText".localized,
            title: "LoadError".localized,
            buttonTitle: "OK".localized
        )
    }
    
    func showFileSavingFailureDialog(withError error: Error) {
        let action = getGoToSettingsAction()
        showDialog(
            withMessage: "SaveFileErrorMessage".localized,
            title: "Save error".localized,
            buttonTitle: "Go to Settings".localized,
            buttonStyle: .default,
            action: action
        )
    }
    
    func showImageSavingFailureDialog(withError error: NSError) {
        let action = getGoToSettingsAction()

        showDialog(
            withMessage: "SaveErrorMessage".localized,
            title: "SaveError".localized,
            buttonTitle: "Go to Settings".localized,
            buttonStyle: .default,
            action: action
        )
    }
    
    func showImageSavingSuccessDialog() {
        showDialog(
            withMessage: "The image has been saved to your photos".localized,
            title: "Saved!".localized,
            buttonTitle: "OK".localized
        )
    }
    
    func showNoCurrentOperatorDialog() {
        showDialog(
            withMessage: "There is no current agent to rate".localized,
            title: "No agents available".localized,
            buttonTitle: "OK".localized
        )
    }
    
    func showSettingsAlertDialog(withMessage message: String) {
        showDialog(
            withMessage: message,
            title: "InvalidSettings".localized,
            buttonTitle: "OK".localized
        )
    }
    
    func showOperatorInfo(withMessage message: String) {
        showDialog(
            withMessage: message,
            title: "Operator Info".localized,
            buttonTitle: "OK".localized
        )
    }

    func showAlertForAccountName() {
        showDialog(
            withMessage: "Alert account name".localized,
            title: "Account".localized,
            buttonTitle: "OK".localized
        )
    }

    // MARK: - Private methods
    private func getGoToSettingsAction() -> (() -> Void) {
        return {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.sharedInstance()?.canOpenURL(settingsUrl) == true {
                #if !TARGET_IS_EXTENSION
                UIApplication.sharedInstance()?.open(settingsUrl)
                #endif
            }
        }
    }
    
    private func dismiss() {
        let time = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.alertController.dismiss(animated: true, completion: nil)
        }
    }
}
