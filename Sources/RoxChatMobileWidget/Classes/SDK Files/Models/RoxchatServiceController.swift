//
//  RoxchatServiceController.swift
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

class RoxchatServiceController {
    
    static let shared = RoxchatServiceController()

    var sessionBuilder: SessionBuilder?
    
    weak var fatalErrorHandlerDelegate: FatalErrorHandlerDelegate?
    weak var departmentListHandlerDelegate: DepartmentListHandlerDelegate?
    weak var notFatalErrorHandler: NotFatalErrorHandler?

    private var roxchatService: RoxchatService?

    func createSession() -> RoxchatService {
        
        stopSession()
        print("createSession")
        let service = RoxchatService(
            fatalErrorHandlerDelegate: self,
            departmentListHandlerDelegate: self,
            notFatalErrorHandler: self
        )

        service.set(sessionBuilder: sessionBuilder)
        service.createSession()
        service.startSession()
        service.setMessageStream()
        
        self.roxchatService = service
        return service
    }
    
    static var currentSession: RoxchatService {
        return RoxchatServiceController.shared.currentSession()
    }
    
    func currentSession() -> RoxchatService {
        return self.roxchatService ?? createSession()
    }
    
    func stopSession() {
        print("stopSession")
        self.roxchatService?.stopSession()
        self.roxchatService = nil
    }
    
    func sessionState() -> ChatState {
        return roxchatService?.sessionState() ?? .unknown
    }
}

extension RoxchatServiceController: FatalErrorHandlerDelegate {
    
    func showErrorDialog(withMessage message: String) {
        self.fatalErrorHandlerDelegate?.showErrorDialog(withMessage: message)
    }
}

extension RoxchatServiceController: DepartmentListHandlerDelegate {
    
    func showDepartmentsList(_ departaments: [Department], action: @escaping (String) -> Void ) {
        self.departmentListHandlerDelegate?.showDepartmentsList(departaments, action: action)
    }
}

extension RoxchatServiceController: NotFatalErrorHandler {
    
    func on(error: RoxchatNotFatalError) {
        self.notFatalErrorHandler?.on(error: error)
    }
    
    func connectionStateChanged(connected: Bool) {
        if !connected && WidgetAppDelegate.shared.applicationWasInactive {
            WidgetAppDelegate.shared.applicationWasInactive.toggle()
            return
        }
        self.notFatalErrorHandler?.connectionStateChanged(connected: connected)
    }
}
