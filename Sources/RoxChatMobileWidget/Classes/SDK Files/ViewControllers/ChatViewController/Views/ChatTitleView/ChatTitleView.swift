//
//  ChatTitleView.swift
//  RoxchatClientLibrary_Example
//
//  Copyright © 2023 Roxchat. All rights reserved.
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

class ChatTitleView: UIView {
    enum State: Equatable {
        case unknown
        case operatorDefined(name: String)
        case operatorIndefined
        case typing
    }

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typingLabel: UILabel!
    @IBOutlet var operatorInfoStackView: UIView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var typingIndicator: TypingIndicator!
    @IBOutlet var typingStackView: UIView!

    var state: State = .unknown {
        didSet {
            stateChanged(to: state)
        }
    }


    private func stateChanged(to state: State) {
        switch state {
        case .unknown:
            operatorInfoStackView.isHidden = true
            logoImageView.isHidden = false
            typingIndicator.removeAllAnimations()
        case .operatorDefined(let name):
            nameLabel.text = name
            typingStackView.isHidden = true
            operatorInfoStackView.isHidden = false
            logoImageView.isHidden = true
            typingIndicator.removeAllAnimations()
        case .operatorIndefined:
            nameLabel.text = "No agent".localized
            typingStackView.isHidden = true
            operatorInfoStackView.isHidden = false
            logoImageView.isHidden = true
            typingIndicator.removeAllAnimations()
        case .typing:
            typingStackView.isHidden = false
            operatorInfoStackView.isHidden = false
            logoImageView.isHidden = true
            typingIndicator.addAllAnimations()
        }
    }
}
