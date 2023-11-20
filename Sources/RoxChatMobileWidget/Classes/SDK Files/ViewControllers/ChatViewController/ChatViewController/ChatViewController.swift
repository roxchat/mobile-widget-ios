//
//  ChatViewController.swift
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
import Nuke
import MobileCoreServices
import RoxchatClientLibrary
import RoxChatKeyboard

class ChatViewController: UIViewController {


    // MARK: Config
    var chatConfig: WMViewControllerConfig?
    var imageViewControllerConfig: WMViewControllerConfig?
    var fileViewControllerConfig: WMViewControllerConfig?

    // MARK: Models
    lazy var navigationBarUpdater = NavigationBarUpdater()
    lazy var roxchatServerSideSettingsManager = RoxchatServerSideSettingsManager()
    lazy var messageCounter = MessageCounter(delegate: self)
    lazy var keyboardNotificationManager = WMKeyboardManager()
    lazy var scrollQueueManager = ScrollQueueManager()
    lazy var filePicker = FilePicker(presentationController: self, delegate: self)
    lazy var alertDialogHandler = AlertController(delegate: self)

    // MARK: Helper Properties
    // Chat
    var chatMessages = [Message]() {
        willSet {
            canReloadRows = newValue.count == chatMessages.count
        }
    }

    // Surveys
    var delayedSurvayQuestion: SurveyQuestion?
    var rateStarsViewController: RateStarsViewController?
    var surveyCommentViewController: SurveyCommentViewController?
    var surveyRadioButtonViewController: SurveyRadioButtonViewController?

    // States
    var surveyCounter = -1
    var searchMessages = [Message]()
    var selectedMessage: Message?
    var showSearchResult = false
    var canReloadRows = false
    var scrollToBottom = false
    var alreadyRatedOperators = [String: Bool]()
    weak var cellWithSelection: WMMessageTableCell?
    
    // MARK: - Outletls
    @IBOutlet var chatTableView: UITableView!
    @IBOutlet var toolbarBackgroundView: WMToolbarBackgroundView!
    @IBOutlet var toolbarView: WMToolbarView!

    // MARK: - Constants
    lazy var keychainKeyRatedOperators = "alreadyRatedOperators"

    // MARK: - Subviews
    // Scroll button
    lazy var scrollButtonView = ScrollButtonView.loadXibView()
    
    // Top bar (top navigation bar)
    lazy var titleView = ChatTitleView.loadXibView()
    lazy var titleViewOperatorAvatarImageView = createUIImageView(contentMode: .scaleAspectFit)
    lazy var thanksView = WMThanksAlertView.loadXibView()
    lazy var connectionErrorView = ConnectionErrorView.loadXibView()
    lazy var chatTestView = ChatTestView.loadXibView()
    
    // Bottom bar
    override var inputAccessoryView: UIView? {
        return presentedViewController?.isBeingDismissed != false ? toolbarBackgroundView : nil
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureNetworkErrorView()
        configureThanksView()
        configureToolbarView()
        setupScrollButton()
        setupAlreadyRatedOperators()
        setupRoxchatSession()
        addTapGesture()

        setupRefreshControl()
        setupChatTableView()

        if true {
            setupTestView()
        }
        subscribeOnKeyboardNotifications()
        configureKeyboardNotificationManager()
        setupServerSideSettingsManager()
        
        // Config parameters
        adjustConfig()
        
        // Nuke animated images
        // ImagePipeline.Configuration._isAnimatedImageDataEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateOperatorInfo(operator: RoxchatServiceController.currentSession.getCurrentOperator(),
                           state: RoxchatServiceController.currentSession.sessionState())
        navigationBarUpdater.set(canUpdate: true)
        updateNavigationBar(WidgetAppDelegate.shared.isApplicationConnected)
        showDepartmensIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let chatConfig = chatConfig as? WMChatViewControllerConfig
        if chatConfig?.openFromNotification == true {
            scrollToUnreadMessage()
            chatConfig?.openFromNotification?.toggle()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationBarUpdater.set(canUpdate: false)
        WMTestManager.testDialogModeEnabled = false
        updateTestModeState()
        WMKeychainWrapper.standard.setDictionary(
            alreadyRatedOperators, forKey: keychainKeyRatedOperators)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if navigationController == nil {
            RoxchatServiceController.shared.stopSession()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async {
            self.toolbarView.messageView.recountViewHeight()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    @objc
    func dismissViewKeyboard() {
        self.toolbarView.messageView.resignMessageViewFirstResponder()
    }

    @objc
    func titleViewTapAction(_ sender: UITapGestureRecognizer) {
        if titleView.state != .unknown && titleView.state != .operatorIndefined {
            self.showRateOperatorDialog()
        }
    }

    @objc
    func scrollToUnreadMessage() {
        scrollQueueManager.perform(kind: .scrollTableView(animated: true)) { [weak self] in
            guard let self = self else { return }
            let lastReadMessageIndexPath = IndexPath(row: self.messageCounter.lastReadMessageIndex, section: 0)
            let firstUnreadMessageIndexPath = IndexPath(row: self.messageCounter.firstUnreadMessageIndex(), section: 0)
            if self.messageCounter.hasNewMessages() && lastReadMessageIndexPath != self.lastVisibleCellIndexPath() {
                self.chatTableView.scrollToRowSafe(at: firstUnreadMessageIndexPath,
                                              at: .bottom,
                                              animated: true)
            } else {
                self.scrollToBottomInMainQueue(animated: true)
            }
        }
    }

    @objc
    func requestMessages() {
        let chatConfig = chatConfig as? WMChatViewControllerConfig
        RoxchatServiceController.currentSession.getNextMessages(messagesCount: chatConfig?.requestMessagesCount) { [weak self] messages in
            DispatchQueue.main.async {
                self?.chatMessages.insert(contentsOf: messages, at: 0)
                self?.messageCounter.increaseLastReadMessageIndex(with: messages.count)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.reloadTableWithNewData()
                self?.chatTableView.layoutIfNeeded()
                if self?.scrollToBottom == true {
                    self?.scrollToBottom(animated: false)
                    self?.scrollToBottom = false
                } else {
                    //self?.chatTableView?.scrollToRowSafe(at: IndexPath(row: messages.count, section: 0), at: .middle, animated: false)
                }

                self?.chatTableView.refreshControl?.endRefreshing()
            }
        }
    }

    @objc
    func rateOperatorByTappingAvatar(recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        let tapLocation = recognizer.location(in: chatTableView)

        guard let tapIndexPath = chatTableView?.indexPathForRow(at: tapLocation) else { return }
        let message = messages()[tapIndexPath.row]

        self.showRateOperatorDialog(operatorId: message.getOperatorID())
    }

    func copyMessage() {
        guard let messageToCopy = selectedMessage else { return }
        UIPasteboard.general.string = messageToCopy.getText()
    }


    func deleteMessage() {
        guard let messageToDelete = selectedMessage else { return }
        RoxchatServiceController.currentSession.delete(
            message: messageToDelete,
            completionHandler: self
        )
    }


    func scrollToBottom(animated: Bool) {
        scrollQueueManager.perform(kind: .scrollTableView(animated: animated)) { [weak self] in
            self?.scrollToBottomInMainQueue(animated: animated)
        }
    }


    func scrollToTop(animated: Bool) {
        if messages().isEmpty {
            return
        }

        let indexPath = IndexPath(row: 0, section: 0)
        self.chatTableView?.scrollToRowSafe(at: indexPath, at: .top, animated: animated)
    }


    func clearTextViewSelection() {
        guard let cellWithSelection = cellWithSelection else { return }
        cellWithSelection.resignTextViewFirstResponder()
        self.cellWithSelection = nil
    }

    func updateOperatorTypingStatus(typing: Bool) {
        if let navigationConfig = chatConfig?.navigationBarConfig as? WMChatNavigationBarConfig,
           navigationConfig.canShowTypingIndicator != false,
           typing {
            titleView.state = .typing
        } else if let name = RoxchatServiceController.currentSession.getCurrentOperator()?.getName() {
            titleView.state = .operatorDefined(name: name)
        }
    }

    func scrollTableView(_ sender: UIButton) {
        self.scrollToBottom(animated: true)
    }

    func setConnectionStatus(connected: Bool) {
        DispatchQueue.main.async {
            WidgetAppDelegate.shared.isApplicationConnected = connected
            self.updateNavigationBar(connected)
            self.connectionErrorView.alpha = connected ? 0 : 1
        }
    }

    func showPopover(cell: UITableViewCell, message: Message, cellHeight: CGFloat) {
        let viewController = PopupActionsViewController()
        let chatConfig = chatConfig as? WMChatViewControllerConfig
        viewController.config = chatConfig?.popupActionControllerConfig
        viewController.modalPresentationStyle = .overFullScreen
        viewController.cellImageViewImage = cell.contentView.takeScreenshot()
        viewController.delegate = self
        UIImageView.animate(withDuration: 0.2, animations: {() -> Void in
            viewController.cellImageView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        })
        guard let globalYPosition = cell.superview?.convert(cell.center, to: nil) else { return }
        viewController.cellImageViewCenterYPosition = globalYPosition.y
        viewController.cellImageViewHeight = cellHeight
        if message.isOperatorType() {
            viewController.originalCellAlignment = .leading
        } else if message.isVisitorType() {
            viewController.originalCellAlignment = .trailing
        }

        if roxchatServerSideSettingsManager.isGlobalReplyEnabled() && message.canBeReplied() {
             viewController.actions.append(.reply)
        }

        if message.canBeCopied() {
            viewController.actions.append(.copy)
        }

        if roxchatServerSideSettingsManager.isMessageEditEnabled() && message.canBeEdited() {
            if message.getData()?.getAttachment() == nil {
                viewController.actions.append(.edit)
            }
            viewController.actions.append(.delete)
        }

        if message.canVisitorReact() {
            if message.getVisitorReaction() == nil || message.canVisitorChangeReaction() {
                viewController.actions.append(.like)
                viewController.actions.append(.dislike)
            }
        }

        if !viewController.actions.isEmpty {
            self.present(viewController, animated: false) {
                UIImageView.animate(withDuration: 0.2, animations: {() -> Void in
                    viewController.cellImageView.transform = .identity
                })
            }
        }
    }

    func sendMessage(_ message: String) {
        RoxchatServiceController.currentSession.send(message: message) {
            self.toolbarView.messageView.setMessageText("")
            // Delete visitor typing draft after message is sent.
            RoxchatServiceController.currentSession.setVisitorTyping(draft: nil)
        }
    }


    func reactMessage(reaction: ReactionString) {
        guard let messageToReact = selectedMessage else { return }
        RoxchatServiceController.currentSession.react(
            reaction: reaction,
            message: messageToReact,
            completionHandler: self
        )
    }

    func reloadTableWithNewData() {
        scrollQueueManager.perform(kind: .reloadTableView) {
            self.chatTableView?.reloadData()
            self.canReloadRows = true
        }
    }

    func updateOperatorInfo(operator: Operator?, state: ChatState) {
        updateOperatorAvatar(`operator`?.getAvatarURL())
        switch state {
        case .queue:
            titleView.state = .operatorIndefined
        case .unknown, .closed:
            titleView.state = .unknown
        default:
            if let currentOperator = `operator`{
                titleView.state = .operatorDefined(name: currentOperator.getName())
            } else {
                titleView.state = .operatorIndefined
            }
        }
    }

    func shouldShowFullDate(forMessageNumber index: Int) -> Bool {
        guard index - 1 >= 0 else { return true }
        let currentMessageTime = chatMessages[index].getTime()
        let previousMessageTime = chatMessages[index - 1].getTime()
        let differenceBetweenDates = Calendar.current.dateComponents(
            [.day],
            from: previousMessageTime,
            to: currentMessageTime
        )
        return differenceBetweenDates.day != 0
    }
    
    // MARK: - Private methods
    private func adjustConfig() {
        adjustChatConfig()
        adjustToolbarConfig()
        adjustQuoteViewConfig()
        adjustEditBarConfig()
        adjustNavigationBarConfig()
        adjustNetworkErrorViewConfig()
    }

    private func adjustChatConfig() {
        if let chatBackgroundColor = chatConfig?.backgroundColor {
            chatTableView.backgroundColor = chatBackgroundColor
        }

        let chatConfig = chatConfig as? WMChatViewControllerConfig

        if let scrollButtonImage = chatConfig?.scrollButtonImage {
            scrollButtonView.setScrollButtonBackgroundImage(scrollButtonImage, state: .normal)
        }

        if let attributedTitle = chatConfig?.refreshControlAttributedTitle {
            chatTableView.refreshControl?.attributedTitle = attributedTitle
        }
    }

    private func adjustToolbarConfig() {
        let chatConfig = chatConfig as? WMChatViewControllerConfig
        toolbarView.config = chatConfig?.toolbarConfig
        toolbarView.adjustConfig()
    }

    private func adjustQuoteViewConfig() {
        let chatConfig = chatConfig as? WMChatViewControllerConfig
        guard let quoteViewConfig = chatConfig?.quoteViewConfig  else { return }
        toolbarView.quoteView.quoteConfig = quoteViewConfig
    }

    private func adjustEditBarConfig() {
        let chatConfig = chatConfig as? WMChatViewControllerConfig
        guard let editBarConfig = chatConfig?.editBarConfig else { return }
        toolbarView.quoteView.editBarConfig = editBarConfig
    }

    private func adjustNavigationBarConfig() {
        guard let navigationBarConfig = chatConfig?.navigationBarConfig else {
            return
        }

        if let onlineTextColor = navigationBarConfig.textColorOnlineState {
            navigationBarUpdater.textColorOnlineState = onlineTextColor
        }

        if let offlineTextColor = navigationBarConfig.textColorOfflineState {
            navigationBarUpdater.textColorOfflineState = offlineTextColor
        }

        if let onlineBackgroundColor = navigationBarConfig.backgroundColorOnlineState {
            navigationBarUpdater.backgroundColorOnlineState = onlineBackgroundColor
        }

        if let offlineBackgroundColor = navigationBarConfig.backgroundColorOfflineState {
            navigationBarUpdater.backgroundColorOfflineState = offlineBackgroundColor
        }

        let chatNavigationConfig = chatConfig?.navigationBarConfig as? WMChatNavigationBarConfig

        if let logoImage = chatNavigationConfig?.logoImage {
            titleView.logoImageView.image = logoImage
        }

        if let typingText = chatNavigationConfig?.typingLabelText {
            titleView.typingLabel.text = typingText
        }
    }

    private func adjustNetworkErrorViewConfig() {
        let chatConfig = chatConfig as? WMChatViewControllerConfig
        guard let networkErrorViewConfig = chatConfig?.networkErrorViewConfig else { return }
        if let image = networkErrorViewConfig.image {
            connectionErrorView.imageView.image = image
        }

        if let text = networkErrorViewConfig.text {
            connectionErrorView.label.text = text
        }

        if let backgroundColor = networkErrorViewConfig.backgroundColor {
            connectionErrorView.backgroundColor = backgroundColor
        }

        if let textColor = networkErrorViewConfig.textColor {
            connectionErrorView.label.textColor = textColor
        }
    }

    private func addRatedOperator(_ notification: Notification) {
        guard let ratingInfoDictionary = notification.userInfo
                as? [String: Int]
        else { return }

        for (id, rating) in ratingInfoDictionary {
            rateOperator(
                operatorID: id,
                rating: rating
            )
        }
    }
    
    private func sendImage(image: UIImage, imageURL: URL?) {
        
        var imageData = Data()
        var imageName = String()
        var mimeType = MimeType()
        
        if let imageURL = imageURL {
            mimeType = MimeType(url: imageURL as URL)
            imageName = imageURL.lastPathComponent
            
            let imageExtension = imageURL.pathExtension.lowercased()
            
            switch imageExtension {
            case "jpg", "jpeg":
                guard let unwrappedData = image.jpegData(compressionQuality: 1.0)
                else { return }
                imageData = unwrappedData
                
            case "heic", "heif":
                guard let unwrappedData = image.jpegData(compressionQuality: 0.5)
                else { return }
                imageData = unwrappedData
                
                var components = imageName.components(separatedBy: ".")
                if components.count > 1 {
                    components.removeLast()
                    imageName = components.joined(separator: ".")
                }
                imageName += ".jpeg"
                
            default:
                guard let unwrappedData = image.pngData()
                else { return }
                imageData = unwrappedData
            }
        } else {
            guard let unwrappedData = image.jpegData(compressionQuality: 1.0)
            else { return }
            imageData = unwrappedData
            imageName = "photo.jpeg"
        }
        
        RoxchatServiceController.currentSession.send(
            file: imageData,
            fileName: imageName,
            mimeType: mimeType.value,
            completionHandler: self
        )
    }
    
    private func sendFile(file: Data, fileURL: URL?) {
        let url = fileURL ?? URL(fileURLWithPath: "document.pdf")
        RoxchatServiceController.currentSession.send(
            file: file,
            fileName: url.lastPathComponent,
            mimeType: MimeType(url: url).value,
            completionHandler: self
        )
    }
    
    private func replyToMessage(_ message: String) {
        guard let messageToReply = selectedMessage else { return }
        RoxchatServiceController.currentSession.reply(
            message: message,
            repliedMessage: messageToReply,
            completion: {
                // Delete visitor typing draft after message is sent.
                RoxchatServiceController.currentSession.setVisitorTyping(draft: nil)
            }
        )
    }

    private func editMessage(_ message: String) {
        guard let messageToEdit = selectedMessage else { return }
        RoxchatServiceController.currentSession.edit(
            message: messageToEdit,
            text: message,
            completionHandler: self
        )
    }

    func scrollToBottomInMainQueue(animated: Bool) {
        guard !self.messages().isEmpty else { return }
        let row = (self.chatTableView.numberOfRows(inSection: 0)) - 1
        let bottomMessageIndex = IndexPath(row: row, section: 0)
        self.chatTableView?.scrollToRowSafe(at: bottomMessageIndex, at: .bottom, animated: animated)
    }

    private func shouldShowOperatorInfo(forMessageNumber index: Int) -> Bool {
        guard chatMessages[index].isOperatorType() else { return false }
        guard index + 1 < chatMessages.count else { return true }
        
        let nextMessage = chatMessages[index + 1]
        let progress = nextMessage.getData()?.getAttachment()?.getDownloadProgress() ?? 100
        if nextMessage.isOperatorType() {
            return progress != 100
        } else {
            return true
        }
    }
    
    // Roxchat methods
    private func setupRoxchatSession() {
        
        RoxchatServiceController.currentSession.setMessageTracker(withMessageListener: self)
        RoxchatServiceController.currentSession.set(operatorTypingListener: self)
        RoxchatServiceController.currentSession.set(currentOperatorChangeListener: self)
        RoxchatServiceController.currentSession.set(chatStateListener: self)
        RoxchatServiceController.currentSession.set(surveyListener: self)
        RoxchatServiceController.currentSession.set(unreadByVisitorMessageCountChangeListener: messageCounter)
        
        RoxchatServiceController.shared.notFatalErrorHandler = self
        RoxchatServiceController.shared.departmentListHandlerDelegate = self
        RoxchatServiceController.shared.fatalErrorHandlerDelegate = self
        
        DispatchQueue.main.async {
            RoxchatServiceController.currentSession.getLastMessages { [weak self] messages in
                self?.chatMessages.insert(contentsOf: messages, at: 0)
                self?.reloadTableWithNewData()
                self?.scrollToBottom(animated: false)
                if messages.count < RoxchatService.ChatSettings.messagesPerRequest.rawValue {
                    self?.scrollToBottom = true
                    self?.requestMessages()
                }
            }
        }
    }

    private func updateOperatorAvatar(_ avatarURL: URL?) {
        guard let avatarURL = avatarURL else {
            self.titleViewOperatorAvatarImageView.image = nil
            return
        }
        let imageDownloadIndicator = CircleProgressIndicator()
        imageDownloadIndicator.lineWidth = 1
        imageDownloadIndicator.strokeColor = documentFileStatusPercentageIndicatorColour
        imageDownloadIndicator.isUserInteractionEnabled = false
        imageDownloadIndicator.isHidden = true
        imageDownloadIndicator.translatesAutoresizingMaskIntoConstraints = false

        //let loadingOptions = ImageLoadingOptions(placeholder: UIImage(),transition: .fadeIn(duration: 0.5))
        let defaultRequestOptions = ImageRequest.Options()
        let imageRequest = ImageRequest(
            url: avatarURL,
            processors: [ImageProcessors.Circle()],
            priority: .normal,
            options: defaultRequestOptions
        )

        ImagePipeline.shared.loadImage(
            with: imageRequest,
            //options: loadingOptions,
            //into: self.titleViewOperatorAvatarImageView,
            progress: { _, completed, total in
                DispatchQueue.global(qos: .userInteractive).async {
                    let progress = Float(completed) / Float(total)
                    DispatchQueue.main.async {
                        if imageDownloadIndicator.isHidden {
                            imageDownloadIndicator.isHidden = false
                            imageDownloadIndicator.enableRotationAnimation()
                        }
                        imageDownloadIndicator.setProgressWithAnimation(
                            duration: 0.1,
                            value: progress
                        )
                    }
                }
            },
            completion: { _ in
                DispatchQueue.main.async {
                    imageDownloadIndicator.isHidden = true
                }
            }
        )
    }

    private func updateNavigationBar(_ isConnected: Bool) {
        navigationBarUpdater.set(isNavigationBarVisible: true)
        navigationBarUpdater.update(with: isConnected ? .connected : .disconnected)
    }

    private func showDepartmensIfNeeded() {
        if let departmentList = RoxchatServiceController.currentSession.departmentList(),
           RoxchatServiceController.currentSession.shouldShowDepartmentSelection() {
            showDepartmentsList(departmentList) { departmentKey in
                RoxchatServiceController.currentSession.startChat(departmentKey: departmentKey, message: nil)
            }
        }
    }

    private func updateScrollButtonView() {
        let chatConfig = chatConfig as? WMChatViewControllerConfig
        guard chatConfig?.showScrollButtonView != false else {
            scrollButtonView.setScrollButtonViewState(.hidden)
            return
        }
        messageCounter.set(lastReadMessageIndex: lastVisibleCellIndexPath()?.row ?? 0)
        let state: ScrollButtonViewState = messageCounter.hasNewMessages() && chatConfig?.showScrollButtonCounter != false ?
            .newMessage : isLastCellVisible() || chatMessages.isEmpty ? .hidden : .visible
        scrollButtonView.setScrollButtonViewState(state)
    }
}

// MARK: - ROXCHAT: DepartmentListHandlerDelegate
extension ChatViewController: DepartmentListHandlerDelegate {
    func showDepartmentsList(_ departaments: [Department], action: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            self.alertDialogHandler.showDepartmentListDialog(
                withDepartmentList: departaments,
                action: action,
                sourceView: self.toolbarView,
                cancelAction: { }
            )
        }
    }
}

// MARK: - ROXCHAT: UIScrollViewDelegate
extension ChatViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateScrollButtonView()
    }

    func recountChatTableFrame(keyboardHeight: CGFloat) -> CGRect {
        let offset = max(keyboardHeight, self.toolbarView.frame.height )
        let height = self.view.frame.height - self.chatTableView.frame.origin.y - offset
        var newFrame = self.chatTableView.frame
        newFrame.size.height = height
        return newFrame
    }

    func recountTableSize() {
        let newFrame = recountChatTableFrame(keyboardHeight: 0)
        self.chatTableView.frame = newFrame
        var scrollButtonFrame = self.scrollButtonView.frame
        scrollButtonFrame.origin.y = newFrame.size.height - 50
        self.scrollButtonView.frame = scrollButtonFrame
        self.view.setNeedsDisplay()
        self.view.setNeedsLayout()
    }

    func isLastCellVisible() -> Bool {
        guard let lastVisibleCell = chatTableView.visibleCells.last else { return false }
        let lastIndexPath = chatTableView.indexPath(for: lastVisibleCell)
        return lastIndexPath?.row == chatMessages.count - 1
    }

    func lastVisibleCellIndexPath() -> IndexPath? {
        guard let lastVisibleCell = chatTableView.visibleCells.last else { return nil }
        let lastIndexPath = chatTableView.indexPath(for: lastVisibleCell)
        return lastIndexPath
    }
}

// MARK: - FilePickerDelegate methods
extension ChatViewController: FilePickerDelegate {
    
    func didSelect(images: [ImageToSend]) {
        for image in images {
            print("didSelect(image: \(String(describing: image.url?.lastPathComponent)), imageURL: \(String(describing: image.url)))")
            guard let imageToSend = image.image else { return }
            self.sendImage(image: imageToSend, imageURL: image.url)
        }
    }
    
    func didSelect(files: [FileToSend]) {
        for file in files {
            print("didSelect(file: \(file.url?.lastPathComponent ?? "nil")), fileURL: \(file.url?.path ?? "nil"))")
            guard let fileToSend = file.file else { return }
            self.sendFile(file: fileToSend,fileURL: file.url)
        }
    }
}

extension ChatViewController: ChatTestViewDelegate {
    
    func getSearchMessageText() -> String {
        let searchText = self.toolbarView.messageView.getMessage()
        self.toolbarView.messageView.setMessageText("")
        return searchText
    }
    
    func toogleAutotest() -> Bool {
        return self.toggleAutotest()
    }
    
    func showSearchResult(searcMessages: [Message]?) {
        showSearchResult(messages: searcMessages)
    }
    
    func clearHistory() {
        removedAllMessages()
    }
}

extension ChatViewController: WMNewMessageViewDelegate {
    func inputTextChanged() {
        RoxchatServiceController.currentSession.setVisitorTyping(draft: self.toolbarView.messageView.getMessage())
    }
    
    func sendMessage() {
        let messageText = self.toolbarView.messageView.getMessage()
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        if self.toolbarView.quoteBarIsVisible() {
            if self.toolbarView.quoteView.currentMode() == .edit {
                if messageText.trimmingCharacters(in: .whitespacesAndNewlines) !=
                    self.toolbarView.quoteView.currentMessage().trimmingCharacters(in: .whitespacesAndNewlines) {
                    self.editMessage(messageText)
                }
            } else {
                self.replyToMessage(messageText)
            }
            self.toolbarView.removeQuoteEditBar()
        } else {
            self.sendMessage(messageText)
        }
        self.toolbarView.messageView.setMessageText("")
        self.selectedMessage = nil
    }
    
    func showSendFileMenu(_ sender: UIButton) { // Send file button pressed
        filePicker.showSendFileMenu(from: sender)
    }
}

extension ChatViewController: MessageCounterDelegate {
    func changed(newMessageCount: Int) {
        var state: ScrollButtonViewState
        let chatConfig = chatConfig as? WMChatViewControllerConfig
        if newMessageCount > 0 && !isLastCellVisible() && chatConfig?.showScrollButtonCounter != false {
            state = .newMessage
            scrollButtonView.setNewMessageCount(newMessageCount)
        } else if newMessageCount >= 0 && !isLastCellVisible() {
            state = .visible
        } else {
            state = .hidden
            RoxchatServiceController.currentSession.setChatRead()
        }
        scrollButtonView.setScrollButtonViewState(state)
    }

    func updateLastMessageIndex(completionHandler: ((Int) -> ())?) {
        completionHandler?(messages().count - 1)
    }

    func updateLastReadMessageIndex(completionHandler: ((Int) -> ())?) {
        completionHandler?(lastVisibleCellIndexPath()?.row ?? 0)
    }
}

extension ChatViewController: NavigationBarUpdaterDelegate {
    func setTitleViewTextColor(_ color: UIColor) {
        titleView.nameLabel.textColor = color
        titleView.typingLabel.textColor = color
        titleView.typingIndicator.circleColour = color
    }
}
