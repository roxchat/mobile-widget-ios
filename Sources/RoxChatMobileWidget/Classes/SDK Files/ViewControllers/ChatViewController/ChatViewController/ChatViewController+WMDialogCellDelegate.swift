//
//  ChatTableViewController+WMDialogCellDelegate.swift
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
import Nuke

extension ChatViewController: WMDialogCellDelegate {
    
    func longPressAction(cell: UITableViewCell, message: Message) {
        selectedMessage = message
        showPopover(cell: cell, message: message, cellHeight: cell.frame.height)
    }

    func imageViewTapped(message: Message, image: ImageContainer?, url: URL?) {
        guard let url = url else { return }
        
        let vc = WMImageViewController.loadViewControllerFromXib()
        vc.config = imageViewControllerConfig
        vc.selectedImageURL = url
        vc.selectedImage = image
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func quoteMessageTapped(message: Message?) {
        guard let messageId = message?.getQuote()?.getMessageID() else { return }
        guard let row = (self.chatMessages.firstIndex{ $0.getServerSideID() == messageId }) else { return }
        let indexPath = IndexPath(row: row, section: 0)
        self.chatTableView.scrollToRowSafe(at: indexPath, at: .middle, animated: false)
        UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
            self.chatTableView.cellForRow(at: indexPath)?.contentView.backgroundColor = quoteBodyLabelColourVisitor
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
                self.chatTableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .clear
            })
        })
    }
    
    public func openFile(message: Message?, url: URL?) {
        let vc = WMFileViewController.loadViewControllerFromXib()
        vc.config = fileViewControllerConfig
        vc.fileDestinationURL = url
        if navigationController?.viewControllers.last?.isFileViewController != true {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func cleanTextView() {
        self.toolbarView.messageView.setMessageText("")
    }

    func canReloadRow() -> Bool {
        return canReloadRows
    }

    func isCellVisible(_ cell: WMMessageTableCell) -> Bool {
        return chatTableView.visibleCells.contains(cell)
    }

    func sendKeyboardRequest(buttonInfoDictionary: [String: String]) {
        guard let messageID = buttonInfoDictionary["Message"],
            let buttonID = buttonInfoDictionary["ButtonID"],
            buttonInfoDictionary["ButtonTitle"] != nil
        else { return }
        if let message = findMessage(withID: messageID),
        let button = findButton(inMessage: message, buttonID: buttonID) {
        // TODO: Send request
        print("Sending keyboard request...")
                    
        RoxchatServiceController.currentSession.sendKeyboardRequest(
            button: button,
            message: message,
            completionHandler: self
        )
        
        } else {
            print("HALT! There isn't such message or button in #function")
        }
    }

    func cellChangeTextViewSelection(_ cell: WMMessageTableCell) {
        cellWithSelection = cell
    }
    
    func reloadCell(_ cell: UITableViewCell) {
        guard let indexPath = chatTableView.indexPath(for: cell) else { return }
        chatTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func findMessage(withID id: String) -> Message? {
        for message in chatMessages {
            if message.getID() == id {
                return message
            }
        }
        return nil
    }
    
    private func findButton(
        inMessage message: Message,
        buttonID: String
    ) -> KeyboardButton? {
        guard let buttonsArrays = message.getKeyboard()?.getButtons() else { return nil }
        let buttons = buttonsArrays.flatMap { $0 }
        
        for button in buttons {
            if button.getID() == buttonID {
                return button
            }
        }
        return nil
    }
}

extension ChatViewController {

    func updateThreadListAndReloadTable(animatingDifferences: Bool = false, _ completionHandler: (() -> Void)? = nil) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        if snapshot.numberOfSections == 0 {
            snapshot.appendSections([0])
        }
        
        let messagesIdentifiers = messages().map{ $0.getID() }
        var uniqueIdentifiers: [String] = []
        for id in messagesIdentifiers {
            if !uniqueIdentifiers.contains(id) {
                uniqueIdentifiers.append(id)
            }
        }
        guard !uniqueIdentifiers.isEmpty else {
            return
        }
    
        snapshot.appendItems(uniqueIdentifiers, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: completionHandler)
    }
}
