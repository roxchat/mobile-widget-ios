//
//  Message.swift
//  RoxchatClientLibrary_Example
//
//  Copyright © 2019 Roxchat. All rights reserved.
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

extension Message {
    
    // MARK: - Methods
    public func isSystemType() -> Bool {
        return self.getType() == .actionRequest
            || self.getType() == .contactInformationRequest
            || self.getType() == .info
            || self.getType() == .keyboard
            || self.getType() == .keyboardResponse
            || self.getType() == .operatorBusy
    }
    
    public func isVisitorType() -> Bool {
        return self.getType() == .visitorMessage
            || self.getType() == .fileFromVisitor
    }
    
    public func isOperatorType() -> Bool {
        return self.getType() == .operatorMessage
            || self.getType() == .fileFromOperator
    }
    
    public func canBeCopied() -> Bool {
        return self.getType() == .operatorMessage
            || self.getType() == .visitorMessage
    }
    
    func isFile() -> Bool {
        return self.getType() == .fileFromOperator
            || self.getType() == .fileFromVisitor
    }
    
    func isText() -> Bool {
        return self.getType() == .operatorMessage
            || self.getType() == .visitorMessage
    }
    
}
