//
//  WMVisitorImageMessageTableViewCell.swift
//  Roxchat
//
//  Copyright © 2021 _roxchat_. All rights reserved.
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

class WMOperatorImageCell: WMImageTableViewCell {
    // MARK: Properties
    // Layers
    private var gradientLayer = CAGradientLayer()

    // Constants
    private let prefferedGradientHeight: CGFloat = 30

    // MARK: Methods
    // Override Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }

    override func initialSetup() -> Bool {
        let setup = super.initialSetup()
        if setup {
            sharpCorner(view: messageView, visitor: false)
            downloadProcessIndicator.setDefaultSetup()
            setGradientBackground()
        }
        return setup
    }

    override func setMessage(message: Message) {
        super.setMessage(message: message)
    }

    // Private Methods
    private func setGradientBackground() {
        gradientLayer.colors = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        imagePreview.layer.addSublayer(gradientLayer)
        updateGradientFrame()
    }

    private func updateGradientFrame() {
        let gradientYEndPoint = prefferedGradientHeight / bounds.height
        gradientLayer.endPoint = CGPoint(x: 0.0, y: gradientYEndPoint)
        gradientLayer.frame = bounds
    }
}
