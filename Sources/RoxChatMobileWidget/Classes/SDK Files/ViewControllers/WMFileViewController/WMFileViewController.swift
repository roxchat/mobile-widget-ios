//
//  WMFileViewController.swift
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

import UIKit
import WebKit
import SnapKit
import CloudKit
import CoreServices

class WMFileViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    // MARK: - Properties
    var fileDestinationURL: URL?
    var config: WMViewControllerConfig?
    
    // MARK: - Private properties
    private var contentWebView = WKWebView()
    private var navigationBarUpdater = NavigationBarUpdater()
    private lazy var alertDialogHandler = AlertController(delegate: self)
    
    // MARK: - Outlets
    @IBOutlet var contentWebViewContainer: UIView!
    @IBOutlet var loadingStatusLabel: UILabel!
    @IBOutlet var loadingStatusIndicator: UIActivityIndicatorView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupLoadingSubiews()
        setupContentWebView()
        loadData()
        // Config
        adjustConfig()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarUpdater.set(canUpdate: true)
        adjustNavigationBarConfig()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationBarUpdater.set(canUpdate: false)
    }
    
    
    @IBAction func saveFile(_ sender: Any) {
        guard let fileToSave = fileDestinationURL else { return }
        let ac = UIActivityViewController(activityItems: [fileToSave], applicationActivities: nil)
        self.present(ac, animated: true)
        ac.completionWithItemsHandler = { type, bool, _, error in
            if bool && (type == .saveToCameraRoll || type == .saveToFile) {
                let saveView = WMSaveView.loadXibView()
                self.view.addSubview(saveView)
                saveView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                saveView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                self.view.bringSubviewToFront(saveView)
                saveView.animateImage()
            }
            if let error = error {
                self.alertDialogHandler.showFileSavingFailureDialog(withError: error)
            }
        }
    }
    
    // MARK: - WKWebView methods
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard keyPath == "estimatedProgress",
            contentWebView.estimatedProgress == 1.0
            else { return }
        
        loadingStatusLabel.isHidden = true
        loadingStatusIndicator.stopAnimating()
        loadingStatusIndicator.isHidden = true
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard navigationAction.navigationType == .linkActivated,
            let url = navigationAction.request.url,
            UIApplication.sharedInstance()?.canOpenURL(url) == true else {
            decisionHandler(.allow)
            return
        }
        #if TARGET_IS_EXTENSION
        extensionContext?.open(url)
        #else
        UIApplication.sharedInstance()?.open(url)
        #endif
        decisionHandler(.cancel)
    }

    // MARK: - Private methods
    private func setupNavigationItem() {
        navigationBarUpdater.set(navigationController: navigationController)
        /// Files App was presented in iOS 11.0
        guard #available(iOS 11.0, *) else { return }

        let rightButton = UIButton(type: .system)
        let buttonImage: UIImage = config?.navigationBarConfig?.rightBarButtonImage ??  fileShare
        rightButton.frame = CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0)
        rightButton.setBackgroundImage(buttonImage, for: .normal)
        rightButton.addTarget(
            self,
            action: #selector(saveFile),
            for: .touchUpInside
        )
        
        rightButton.snp.remakeConstraints { (make) -> Void in
            make.height.width.equalTo(25.0)
        }
        
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupLoadingSubiews() {
        loadingStatusLabel.text = "Loading File...".localized
        loadingStatusIndicator.startAnimating()
    }
    
    /// Workaround for iOS < 11.0
    private func setupContentWebView() {
        contentWebView.navigationDelegate = self
        contentWebView.allowsLinkPreview = true
        contentWebView.uiDelegate = self
        contentWebView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
        
        contentWebViewContainer.addSubview(contentWebView)
        contentWebViewContainer.sendSubviewToBack(contentWebView)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        contentWebView.translatesAutoresizingMaskIntoConstraints = false
        contentWebView.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func loadData() {
        guard let destinationURL = fileDestinationURL else { return }
        contentWebView.load(URLRequest(url: destinationURL))
    }

    private func adjustConfig() {
        adjustLoadingTextConfig()
        adjustActivityIndicatorConfig()
        adjustBackgroundColorConfig()
    }

    private func adjustNavigationBarConfig() {
        guard let navigationConfig = config?.navigationBarConfig else {
            navigationBarUpdater.update(with: .clear)
            navigationBarUpdater.set(canUpdate: false)
            return
        }
        let appConnected = WidgetAppDelegate.shared.isApplicationConnected
        navigationBarUpdater.textColorOnlineState = navigationConfig.textColorOnlineState
        navigationBarUpdater.textColorOfflineState = navigationConfig.textColorOfflineState
        navigationBarUpdater.backgroundColorOnlineState = navigationConfig.backgroundColorOnlineState
        navigationBarUpdater.backgroundColorOfflineState = navigationConfig.backgroundColorOfflineState
        navigationBarUpdater.set(canUpdate: true)
        navigationBarUpdater.update(with: appConnected ? .connected : .disconnected)
    }

    private func adjustLoadingTextConfig() {
        guard let config = config as? WMFileViewControllerConfig,
              let loadingText = config.loadingLabelText else {
            return
        }
        loadingStatusLabel.attributedText = loadingText
    }

    private func adjustActivityIndicatorConfig() {
        guard let config = config as? WMFileViewControllerConfig else {
            return
        }
        let needStartAnimation = config.canShowLoadingIndicator != false
        needStartAnimation ? (loadingStatusIndicator.startAnimating()) : (loadingStatusIndicator.stopAnimating())
    }

    private func adjustBackgroundColorConfig() {
        guard let backgroundColor = config?.backgroundColor else { return }
        contentWebView.backgroundColor = backgroundColor
    }

}

