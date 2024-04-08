//
//  RoxchatAccountConfigManager.swift
//  RoxchatClientLibrary_Example
//
//  Copyright © 2022 Roxchat. All rights reserved.
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
import RoxchatClientLibrary

class RoxchatServerSideSettingsManager {

    private var roxchatServerSideSettings: RoxchatServerSideSettings?

    func getServerSideSettings(_ completionHandler: ServerSideSettingsCompletionHandler) {
        RoxchatServiceController.currentSession.getServerSideSettings(completionHandler: completionHandler)
    }

    func isGlobalReplyEnabled() -> Bool {
        guard let isGlobalReplyEnabled = roxchatServerSideSettings?.accountConfig.webAndMobileQuoting else {
            return false
        }
        return isGlobalReplyEnabled
    }

    func isMessageEditEnabled() -> Bool {
        guard let isMessageEditEnabled = roxchatServerSideSettings?.accountConfig.visitorMessageEditing else {
            return false
        }
        return isMessageEditEnabled
    }
    
    func isRateOperatorEnabled() -> Bool {
        guard let isRateOperatorEnabled = roxchatServerSideSettings?.accountConfig.rateOperator else {
            return true
        }
        return isRateOperatorEnabled
    }
    
    func showRateOperatorButton() -> Bool {
        guard let showRateOperatorButton = roxchatServerSideSettings?.accountConfig.showRateOperator else {
            return true
        }
        return showRateOperatorButton
    }
}

extension RoxchatServerSideSettingsManager: ServerSideSettingsCompletionHandler {
    func onSuccess(roxchatServerSideSettings: RoxchatServerSideSettings) {
        self.roxchatServerSideSettings = roxchatServerSideSettings
    }

    func onFailure() {

    }

}
