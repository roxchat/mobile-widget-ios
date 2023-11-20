//
//  NavigationBarUpdater.swift
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

import UIKit

protocol NavigationBarUpdaterDelegate: AnyObject {
    func setTitleViewTextColor(_ color: UIColor)
}

class NavigationBarUpdater {

    var textColorOnlineState: UIColor?
    var textColorOfflineState: UIColor?
    var backgroundColorOnlineState: UIColor?
    var backgroundColorOfflineState: UIColor?

    private var canUpdateBar: Bool = true
    private var isBarVisible: Bool?
    private var navigationController: UINavigationController?

    private weak var delegate: NavigationBarUpdaterDelegate?

    func update(with style: NavigationBarStyle) {
        guard canUpdateBar else { return }

        let isEnabled: Bool = false
        var isTranslucent: Bool = false
        let barTintColor: UIColor
        let backgroundColor: UIColor

        switch style {
        case .connected:
            barTintColor = textColorOnlineState ?? navigationBarTintColour
            backgroundColor = backgroundColorOnlineState ?? navigationBarBarTintColour
        case .disconnected:
            barTintColor = textColorOfflineState ?? navigationBarTintColour
            backgroundColor = backgroundColorOfflineState ?? navigationBarNoConnectionColour
        case .clear:
            isTranslucent = true
            barTintColor = navigationBarTintColour
            backgroundColor = navigationBarClearColour
        case .defaultStyle:
            barTintColor = navigationBarTintColour
            backgroundColor = navigationBarBarTintColour
        }

        navigationController?.setTopBar(
            isEnabled: isEnabled,
            isTranslucent: isTranslucent,
            barTintColor: barTintColor,
            backgroundColor: backgroundColor)
        delegate?.setTitleViewTextColor(barTintColor)
    }

    func setupNavigationBar() {
        // Fixing 'shadow' on top of the main colour
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    func set(canUpdate: Bool) {
        canUpdateBar = canUpdate
    }

    func set(delegate: NavigationBarUpdaterDelegate) {
        self.delegate = delegate
    }

    func set(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func set(isNavigationBarVisible: Bool) {
        isBarVisible = isNavigationBarVisible
        navigationController?.setNavigationBarHidden(!isNavigationBarVisible, animated: true)
    }

    func isNavigationBarVisible() -> Bool {
        return isBarVisible == true
    }

}

enum NavigationBarStyle {
    case connected
    case disconnected
    case clear
    case defaultStyle
}
