//
//  PopoverActionTableViewCell.swift
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

class PopupActionsTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    private lazy var actionNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Methods
    func setupCell(forAction action: PopupAction, with config: WMPopupActionCellConfig?) {
        var defaultActionImage: UIImage
        let defaultActionText = action.rawValue
        let configActionImage = config?.actionImage
        let configActionText = config?.actionText

        self.addSubview(actionNameLabel)
        self.addSubview(actionImageView)
        setupConstraints()
        
        switch action {
        case .reply:
            defaultActionImage = replyImage
        case .copy:
            defaultActionImage = copyImage
        case .edit:
            defaultActionImage = editImage
        case .delete:
            defaultActionImage = deleteImage
        case .like:
            defaultActionImage = editImage
        case .dislike:
            defaultActionImage = editImage
        }

        adjustConfig(config: config)

        fillCell(
            actionText: configActionText ?? defaultActionText,
            actionImage: configActionImage ?? defaultActionImage
        )
    }
    
    // MARK: - Private methods
    private func setupConstraints() {
        actionNameLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            // For some reason this layout only works for iOS 13+ only, not iOS 11+ as supposed to
            if #available(iOS 13.0, *) {
                make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
                    .inset(10)
            } else {
                make.leading.equalToSuperview()
                    .inset(10)
            }
        }
        
        actionImageView.snp.remakeConstraints { (make) in
            // For some reason this layout only works for iOS 13+ only, not iOS 11+ as supposed to
            if #available(iOS 13.0, *) {
                make.trailing.equalTo(self.safeAreaLayoutGuide)
                    .inset(10)
                make.top.bottom.equalTo(self.safeAreaLayoutGuide)
                    .inset(10)
                make.leading.equalTo(actionNameLabel.snp.trailing)
                    .offset(10)
            } else {
                make.trailing.bottom.equalToSuperview()
                    .inset(10)
                make.top.bottom.equalToSuperview()
                    .inset(10)
            }
            make.centerY.equalTo(actionNameLabel.snp.centerY)
            make.width.equalTo(actionImageView.snp.height)
        }
    }
    
    private func fillCell(actionText: String, actionImage: UIImage) {
        actionNameLabel.text = actionText
        actionImageView.image = actionImage
    }

    private func adjustConfig(config: WMPopupActionCellConfig?) {
        if let backgroundColor = config?.backgroundColor {
            self.backgroundColor = backgroundColor
        }

        if let cornerRadius = config?.cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }

        if let roundCorners = config?.roundCorners {
            self.roundCorners(roundCorners, radius: config?.cornerRadius ?? 0)
        }
        
        if let titleAttributes = config?.titleAttributes {
            actionNameLabel.attributedText = NSAttributedString(
                string: actionNameLabel.text ?? "",
                attributes: titleAttributes
            )
        
        }

        if let strokeWidth = config?.strokeWidth {
            layer.borderWidth = strokeWidth
        }

        if let strokeColor = config?.strokeColor {
            layer.borderColor = strokeColor.cgColor
        }
    }
}
