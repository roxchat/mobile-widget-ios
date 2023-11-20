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
    var processingPersonalDataUrl: String?

    // MARK: Models
    lazy var navigationBarUpdater = NavigationBarUpdater()
    lazy var roxchatServerSideSettingsManager = RoxchatServerSideSettingsManager()
    lazy var messageCounter = MessageCounter(delegate: self)
    lazy var keyboardNotificationManager = WMKeyboardManager()
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
    var alreadyRatedOperators = [String: Bool]()
    var dataSource: UITableViewDiffableDataSource<Int, String>!
    var delayedScrollLink: String?
    weak var cellWithSelection: WMMessageTableCell?
    lazy var dateFormatter = ChatViewController.createMessageDateFormatter()
    
    // MARK: - Outletls
    @IBOutlet var chatTableView: UITableView!
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
    
    let chatMessagesQueue = DispatchQueue(label: "ru.roxchat.chatMessagesQueue", attributes: .concurrent)
    
    // Bottom bar
    override var inputAccessoryView: UIView? {
        presentedViewController?.isBeingDismissed != false ? toolbarView : nil
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
        self.setupTableViewDataSource()
        configureToolbarView()
        setupScrollButton()
        setupAlreadyRatedOperators()
        setupRoxchatSession()
        addTapGesture()

        setupRefreshControl()
        if true {
            setupTestView()
        }
        subscribeOnKeyboardNotifications()
        configureKeyboardNotificationManager()
        setupServerSideSettingsManager()
        setupTableView()
        // Config parameters
        adjustConfig()
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
        updateNavigationBar(true)
        navigationBarUpdater.set(canUpdate: false)
        WMTestManager.testDialogModeEnabled = false
        updateTestModeState()
        WMKeychainWrapper.standard.setDictionary(
            alreadyRatedOperators, forKey: keychainKeyRatedOperators)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let lastController = navigationController?.viewControllers.last
        if let presentedVC = presentedViewController as? UIImagePickerController {
            if presentedVC.sourceType == .camera {
                return
            }
        }
        if navigationController == nil || lastController?.isImageViewController == false && lastController?.isFileViewController == false && lastController?.isProcessingPersonalData == false {
            RoxchatServiceController.shared.stopSession()
            dataSource = nil
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
        unsubscribeFromKeyboardNotifications()
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
        let lastReadMessageIndexPath = IndexPath(row: self.messageCounter.lastReadMessageIndex, section: 0)
        let firstUnreadMessageIndexPath = IndexPath(row: self.messageCounter.firstUnreadMessageIndex(), section: 0)
        if self.messageCounter.hasNewMessages() && lastReadMessageIndexPath != self.lastVisibleCellIndexPath() {
            self.chatTableView.scrollToRowSafe(at: firstUnreadMessageIndexPath,
                                               at: .bottom,
                                               animated: true)
        } else {
            self.scrollToBottom(animated: true)
        }
    }

    @objc
    func requestMessages() {
        let chatConfig = chatConfig as? WMChatViewControllerConfig
        RoxchatServiceController.currentSession.getNextMessages(messagesCount: chatConfig?.requestMessagesCount) { [weak self] messages in
            self?.chatMessagesQueue.async(flags: .barrier) {
                self?.chatMessages.insert(contentsOf: messages, at: 0)
                self?.messageCounter.increaseLastReadMessageIndex(with: messages.count)
                
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.updateThreadListAndReloadTable()
                self?.chatTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func scrollToDelayedLink(_ link: String, animated: Bool) {
        guard let row = self.messages().firstIndex(where: { $0.getID() == link}) else {
            return
        }

        self.chatTableView.scrollToRowSafe(
            at: IndexPath(row: row, section: 0),
            at: .bottom,
            animated: animated
        )
        self.delayedScrollLink = nil
    }
    
    func scrollToBottom(animated: Bool) {
        guard UIApplication.shared.applicationState == .active else { return }
        guard let lastMessage = messages().last else { return }
        let lastMessageIndexPath = index(for: lastMessage) ?? IndexPath()
        let currentContentOffset = chatTableView.contentOffset.y
        let maxContentOffset = chatTableView.contentSize.height - view.bounds.height
        let contentOffsetDelta = maxContentOffset - currentContentOffset

        if contentOffsetDelta >= view.bounds.height || !animated {
            self.chatTableView.scrollToRowSafe(
                at: lastMessageIndexPath,
                at: .bottom,
                animated: animated
            )
        } else {
            // This implementation required for smooth scrolling experience.
            UIView.animate(
                withDuration: 0.3,
                delay: .zero,
                options: .curveEaseOut,
                animations: { [weak self] in
                    self?.chatTableView.scrollToRowSafe(
                        at: lastMessageIndexPath,
                        at: .bottom,
                        animated: false
                    )
                }
            )
        }
        RoxchatServiceController.currentSession.setChatRead()
        print("scrollToBottom animated \(animated)")
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
    
    func checkAgreement() {
        if roxchatServerSideSettingsManager.showProcessingPersonalDataCheckbox() {
            let vc = ProcessingPersonalData.loadViewControllerFromXib()
            vc.agreementUrlString = roxchatServerSideSettingsManager.getProcessingPersonalDataUrl() ?? processingPersonalDataUrl ?? "https://rox.chat/doc/agreement/"
            
            navigationController?.pushViewController(vc, animated: true)
        }
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

        let scrollImage = chatConfig?.scrollButtonImage ?? scrollButtonImage
        scrollButtonView.setScrollButtonBackgroundImage(scrollImage, state: .normal)

        if let attributedTitle = chatConfig?.refreshControlAttributedTitle {
            chatTableView.refreshControl?.attributedTitle = attributedTitle
        }
        
        if let refreshControlTintColor = chatConfig?.refreshControlTintColor {
            chatTableView.refreshControl?.tintColor = refreshControlTintColor
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
        RoxchatServiceController.currentSession.set(visitSessionStateListener: self)
        RoxchatServiceController.currentSession.set(unreadByVisitorMessageCountChangeListener: messageCounter)
        
        RoxchatServiceController.shared.notFatalErrorHandler = self
        RoxchatServiceController.shared.departmentListHandlerDelegate = self
        RoxchatServiceController.shared.fatalErrorHandlerDelegate = self
        
        RoxchatServiceController.currentSession.getLastMessages { [weak self] messages in
            guard let self = self else { return }
            self.chatMessagesQueue.async(flags: .barrier) {
                self.chatMessages.insert(contentsOf: messages, at: 0)
                DispatchQueue.main.async {
                    if messages.count < RoxchatService.ChatSettings.messagesPerRequest.rawValue {
                        self.requestMessages()
                    }
                }
            }
            DispatchQueue.main.async {
                self.becomeFirstResponder()
                self.updateThreadListAndReloadTable()
                self.scrollToBottom(animated: true)
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

        let defaultRequestOptions = ImageRequest.Options()
        let imageRequest = ImageRequest(
            url: avatarURL,
            processors: [ImageProcessors.Circle()],
            priority: .normal,
            options: defaultRequestOptions
        )

        ImagePipeline.shared.loadImage(
            with: imageRequest,
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
        if state == .hidden {
            RoxchatServiceController.currentSession.setChatRead()
        }
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

    func isLastCellVisible() -> Bool {
        var visibleTableViewBounds = chatTableView.bounds
        visibleTableViewBounds.size.height -= chatTableView.contentInset.bottom - view.safeAreaInsets.bottom
        let systemVisibleCells = chatTableView.visibleCells
        let lastVisibleCell = systemVisibleCells
            .filter { cell in
                let cellFrame = cell.convert(cell.bounds, to: chatTableView)
                return cellFrame.intersects(visibleTableViewBounds)
            }
            .last

        guard let lastVisibleCell = lastVisibleCell,
              let actuallyLastIndexPath = messages().last else { return false }
        let lastVisibleIndexPath = chatTableView.indexPath(for: lastVisibleCell)
        return lastVisibleIndexPath == index(for: actuallyLastIndexPath)
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
        RoxchatServiceController.currentSession.send(
            images: images,
            completionHandler: self
        )
    }

    func didSelect(files: [FileToSend]) {
        RoxchatServiceController.currentSession.send(
            files: files,
            completionHandler: self
        )
    }
}

extension ChatViewController: ChatTestViewDelegate {
    func getConfig() -> RoxchatServerSideSettingsManager? {
        return roxchatServerSideSettingsManager
    }
    
    func sendResolution(answer: Int) {
        if let operatorID = currentOperatorId() {
           RoxchatServiceController.currentSession.sendResolution(withID: operatorID, answer: answer, completionHandler: self)
        } else {
            onFailure(error: SendResolutionError.operatorNotInChat)
        }
    }
    
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
        toolbarView.messageView.setMessageText("")
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        if self.toolbarView.isQuoteViewVisible() {
            hideQuoteView()
            if self.toolbarView.quoteView.currentMode == .edit {
                if messageText.trimmingCharacters(in: .whitespacesAndNewlines) !=
                    self.toolbarView.quoteView.currentMessage.trimmingCharacters(in: .whitespacesAndNewlines) {
                    self.editMessage(messageText)
                }
            } else {
                self.replyToMessage(messageText)
            }
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
            setLastVisibleMessageRead()
        } else if newMessageCount >= 0 && !isLastCellVisible() {
            state = .visible
            setLastVisibleMessageRead()
        } else {
            state = .hidden
            RoxchatServiceController.currentSession.setChatRead()
        }
        scrollButtonView.setScrollButtonViewState(state)
    }
    
    private func setLastVisibleMessageRead() {
        let messages = messages()
        if let lastVisibleCellIndex = lastVisibleCellIndexPath()?.row,
            lastVisibleCellIndex < messages.count,
            lastVisibleCellIndex > 0 {
            RoxchatServiceController.currentSession.setChatRead(message: messages[lastVisibleCellIndex - 1])
        }
    }

    func updateLastMessageIndex(completionHandler: ((Int) -> ())?) {
        completionHandler?(messages().count - 1)
    }

    func updateLastReadMessageIndex(newValue: Int, completionHandler: ((Int) -> ())?) {
        completionHandler?(messages().count - 1 - newValue)
    }
}

extension ChatViewController: NavigationBarUpdaterDelegate {
    func setTitleViewTextColor(_ color: UIColor) {
        titleView.nameLabel.textColor = color
        titleView.typingLabel.textColor = color
        titleView.typingIndicator.circleColour = color
    }
}
