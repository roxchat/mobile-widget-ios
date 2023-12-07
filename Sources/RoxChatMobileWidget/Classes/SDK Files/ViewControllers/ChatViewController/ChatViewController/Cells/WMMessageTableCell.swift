//
//  WMMessageTableCell.swift
//  RoxchatClientLibrary_Example
//
//  Copyright © 2021 Roxchat. All rights reserved.
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

protocol WMDialogCellDelegate: AnyObject {
    func quoteMessageTapped(message: Message?)
    func imageViewTapped(message: Message, image: ImageContainer?, url: URL?)
    func openFile(message: Message?, url: URL?)
    func longPressAction(cell: UITableViewCell, message: Message)
    func cleanTextView()
    func sendKeyboardRequest(buttonInfoDictionary: [String: String])
    func cellChangeTextViewSelection(_ cell: WMMessageTableCell)
    func canReloadRow() -> Bool
    func isCellVisible(_ cell: WMMessageTableCell) -> Bool
    func reloadCell(_ cell: UITableViewCell)
}

class WMMessageTableCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet var time: UILabel?

    private var cellWasInited = false
    var cellMessageWasInited = false
    var config: WMAbstractCellConfig?
    
    @IBOutlet var messageView: UIView?
    
    // operator
    @IBOutlet var authorName: UILabel?
    // visitor
    @IBOutlet var sendStatus: UIImageView?
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView?
    
    // quote
    @IBOutlet var quoteView: UIView?
    
    weak var delegate: WMDialogCellDelegate?
    var message: Message!
    
    static let timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    func setMessage(message: Message) {
        self.message = message
        let timeString = WMMessageTableCell.timeFormatter.string(from: message.getTime())
        let time: String
        if message.isEdited() {
            time = "edited".localized + " " + timeString
        } else {
            time = timeString
        }
        self.time?.text = time
        self.authorName?.text = message.getSenderName()
        self.updateStatus(sendStatus: message.getSendStatus() == .sent, readStatus: message.isReadByOperator())
    }
    
    func getMessage() -> Message? {
        return self.message
    }
    
    func initialSetup() -> Bool {
        
        if !cellWasInited {
            self.cellWasInited = true
            
            let longPressPopupGestureRecognizer = UILongPressGestureRecognizer(
                target: self,
                action: #selector(longPressAction)
            )
            longPressPopupGestureRecognizer.minimumPressDuration = 0.2
            longPressPopupGestureRecognizer.cancelsTouchesInView = false
            self.gestureRecognizers = nil
            self.addGestureRecognizer(longPressPopupGestureRecognizer)
            // quote view init
            if quoteView != nil {
                let tapGestureRecognizer = UITapGestureRecognizer(
                    target: self,
                    action: #selector(quoteViewTapped)
                )
                self.quoteView?.gestureRecognizers = nil
                self.quoteView?.addGestureRecognizer(tapGestureRecognizer)
                
                self.quoteView?.layer.cornerRadius = 10
                //            self.quoteView.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            }
            return true
        }
        return false
    }
    
    func sharpCorner(view: UIView?, visitor: Bool, radius: CGFloat = 10) {
        if !visitor {
            view?.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: radius)
        } else {
            view?.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], radius: radius)
        }
    }

    func applyConfig() {
        guard let config = config else { return }
        
        if let attributes = config.titleAttributes {
            authorName?.attributedText = NSAttributedString(
                string: authorName?.text ?? "",
                attributes: attributes
            )
        }

        if let backgroundColor = config.backgroundColor {
            messageView?.backgroundColor = backgroundColor
        }

        if let cornerRadius = config.cornerRadius {
            if let roundCorners = config.roundCorners {
                messageView?.roundCorners(roundCorners, radius: cornerRadius)
            } else {
                sharpCorner(view: messageView, visitor: message.isVisitorType(), radius: cornerRadius)
            }
        }
        
        if let strokeColor = config.strokeColor {
            messageView?.layer.borderColor = strokeColor.cgColor
        }
        
        if let strokeWidth = config.strokeWidth {
            messageView?.layer.borderWidth = strokeWidth
        }
    }
    
    func updateStatus(sendStatus: Bool, readStatus: Bool) {
        if sendStatus {
            activityIndicatorView?.stopAnimating()
            activityIndicatorView?.isHidden = true
        } else {
            activityIndicatorView?.startAnimating()
            activityIndicatorView?.isHidden = false
        }
        
        self.sendStatus?.isHidden = !sendStatus
        if readStatus {
            self.sendStatus?.image = .loadImageFromWidget(named: "ReadByOperator")
        } else {
            self.sendStatus?.image = .loadImageFromWidget(named: "Sent")
        }
    }

    func resignTextViewFirstResponder() {}
    
    @objc func longPressAction(sender: UILongPressGestureRecognizer) {
        self.delegate?.longPressAction(cell: self, message: self.message)
    }
    
    @objc func quoteViewTapped() {
        self.delegate?.quoteMessageTapped(message: self.message)
    }
    
    @objc func sendKeyboardRequest(keyboardRequest: [String: String]) {
        self.delegate?.sendKeyboardRequest(buttonInfoDictionary: keyboardRequest)
    }
}
