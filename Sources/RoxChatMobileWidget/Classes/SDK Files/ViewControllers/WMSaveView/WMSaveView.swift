//
//  WMSaveView.swift
//  Roxchat
//
//  Copyright © 2020 _roxchat_. All rights reserved.
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

class WMSaveView: UIView {

    var mainColor: UIColor = roxchatCyan
    @IBOutlet var circleView: UIView!
    @IBOutlet var checkmark: CheckmarkView!
    
    override func loadXibViewSetup() {
        self.layer.cornerRadius = 10
        circleView.layer.cornerRadius = 20
        circleView.layer.borderWidth = 2
        setupColor()
        self.alpha = 0
    }
    
    func animateImage() {
        WMSaveView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }){ _ in
            self.checkmark.animateCheckmark()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                WMSaveView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.alpha = 0
                }){ _ in
                    self.removeFromSuperview()
                }
            }
        }
    }

    func setupColor() {
        circleView.layer.borderColor = mainColor.cgColor
        checkmark.mainColor = mainColor
    }
}


class CheckmarkView: UIView {
    var mainColor: UIColor = roxchatCyan

    @objc override dynamic class var layerClass: AnyClass {
        get { return CAShapeLayer.self }
    }
    
    public func animateCheckmark() {
        setupLayer()
        guard let layer = layer as? CAShapeLayer else { return }
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        layer.add(animation, forKey: nil)
        DispatchQueue.main.async {
            layer.strokeEnd = 1.0
        }
    }

    func setupLayer() {
        guard let layer = layer as? CAShapeLayer else { return }
        layer.lineWidth = 2
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = mainColor.cgColor
        layer.strokeEnd = 0.0
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: bounds.midY))
        path.addLine(to: CGPoint(x: 19, y: bounds.midY + 8))
        path.addLine(to: CGPoint(x: 31, y: bounds.midY - 8))
        layer.path = path.cgPath
    }
}
