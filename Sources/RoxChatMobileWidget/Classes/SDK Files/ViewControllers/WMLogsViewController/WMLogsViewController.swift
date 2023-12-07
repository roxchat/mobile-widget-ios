//
//  WMLogsViewController.swift
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
import RoxchatClientLibrary

class WMLogsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollButton: UIButton!

    lazy var navigationBarUpdater = NavigationBarUpdater()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextView()
        setupScrollButtonImage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBar()
    }

    @IBAction private func scrollToBottom() {
        if textView.text.count > 0 {
            let location = textView.text.count - 1
            let bottom = NSMakeRange(location, 1)
            textView.scrollRangeToVisible(bottom)
        }
    }

    private func setupTextView() {
        let logs = WidgetLogManager.shared.getLogs()
        logs.forEach { log in
            addLog(log)
        }
    }

    private func addLog(_ log: String) {
        textView.text.append("\(log) \n \n")
    }

    private func setupScrollButtonImage() {
        scrollButton.setTitle(nil, for: .normal)
        scrollButton.setBackgroundImage(scrollButtonImage, for: .normal)
    }

    private func updateNavigationBar() {
        navigationBarUpdater.set(isNavigationBarVisible: true)
        navigationBarUpdater.update(with: .defaultStyle)
    }

    private func setupNavigationBarUpdater() {
        navigationBarUpdater.set(navigationController: navigationController)
    }
}

extension WMLogsViewController: WidgetLogManagerObserver {
    func didGetNewLog(log: String) {
        addLog(log)
        print(log)
    }
}
