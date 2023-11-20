//
//  WMImageMessageCellTableViewCell.swift
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
import UIKit
import Nuke
import FLAnimatedImage

class WMImageTableViewCell: WMMessageTableCell, WMFileDownloadProgressListener {


    // MARK: Properties
    // Subviews
    @IBOutlet var imagePreview: FLAnimatedImageView!
    @IBOutlet var downloadProcessIndicator: CircleProgressIndicator!

    // Constraints
    @IBOutlet private var imageAspectConstraint: NSLayoutConstraint!
    @IBOutlet private var imageWidthConstraint: NSLayoutConstraint!

    // Common Properties
    private var url: URL?
    private var imageInfo: ImageInfo?
    private var currentAspectRaito: CGFloat = -1
    private var animatedImage: ImageContainer?


    // MARK: Mehtods
    // Override Methods
    override func initialSetup() -> Bool {
        let setup = super.initialSetup()
        if setup {
            setupImageTapGesture()
        }
        return setup
    }

    override func setMessage(message: Message) {
        super.setMessage(message: message)
        imagePreview.image = loadingPlaceholderImage
        guard let attachment = message.getData()?.getAttachment(), let imageURL = WMDownloadFileManager.shared.urlFromFileInfo(attachment.getFileInfo()) else {
            return
        }

        url = imageURL
        imageInfo = attachment.getFileInfo().getImageInfo()
        setupPreviewConstraints()
        WMFileDownloadManager.shared.subscribeForImage(url: imageURL, progressListener: self)
    }

    override func applyConfig() {
        if let cornerRadius = config?.cornerRadius {
            if let roundCorners = config?.roundCorners {
                messageView?.roundCorners(roundCorners, radius: cornerRadius)
                imagePreview.roundCorners(roundCorners, radius: cornerRadius)
            } else {
                let roundCorners: CACornerMask = [
                    .layerMaxXMaxYCorner,
                    .layerMaxXMinYCorner,
                    .layerMinXMinYCorner,
                    .layerMinXMaxYCorner
                ]
                messageView?.roundCorners(roundCorners, radius: cornerRadius)
                imagePreview.roundCorners(roundCorners, radius: cornerRadius)
            }
        }
        
        if let strokeColor = config?.strokeColor {
            messageView?.layer.borderColor = strokeColor.cgColor
            imagePreview?.layer.borderColor = strokeColor.cgColor
        }
        
        if let strokeWidth = config?.strokeWidth {
            messageView?.layer.borderWidth = strokeWidth
            imagePreview?.layer.borderWidth = strokeWidth
        }
    }

    // Common Methods
    @objc func imageViewTapped() {
        self.delegate?.imageViewTapped(message: self.message, image: self.animatedImage ?? (self.imagePreview.image != nil  ? ImageContainer(image: self.imagePreview.image!) : nil), url: self.url)
    }
    
    func progressChanged(url: URL, progress: Float, image: ImageContainer?, error: Error?) {
        if url != self.url { return }
        guard error == nil else {
            WMFileDownloadManager.shared.addDamagedImageMessage(id: message.getID())
            delegate?.reloadCell(self)
            return
        }
        guard let image = image else {
            handleProgress(progress)
            return
        }
        self.imagePreview.image = image.image
        if let data = image.data {
            self.imagePreview.animatedImage = FLAnimatedImage(gifData: data)
            self.imagePreview.startAnimating()
            self.animatedImage = image
        }
        self.downloadProcessIndicator.isHidden = true
    }

    // Private Methods
    private func setupPreviewConstraints() {
        let imageInfoAspectRatio = CGFloat(imageInfo?.getHeight() ?? 1) / CGFloat(imageInfo?.getWidth() ?? 1)
        updateAspectConstraint(aspectRatio: imageInfoAspectRatio)
        updateWidthConstraint()
    }

    private func handleProgress(_ progress: Float) {
        if progress == 1.0 {
            self.downloadProcessIndicator.isHidden = true
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) { [ weak self ] in
                guard let self = self, self.delegate?.isCellVisible(self) ?? false else { return }
                WMFileDownloadManager.shared.subscribeForImage(url: self.url!, progressListener: self)
            }
        } else if progress != 0.0 {
            self.downloadProcessIndicator.isHidden = false
            self.downloadProcessIndicator.updateImageDownloadProgress(progress)
        }
    }

    private func updateAspectConstraint(aspectRatio: CGFloat) {
        guard self.currentAspectRaito != aspectRatio else { return }

        self.currentAspectRaito = aspectRatio
        self.imageAspectConstraint.isActive = false
        self.imagePreview.removeConstraint(self.imageAspectConstraint)

        defer {
            self.imagePreview.addConstraint(self.imageAspectConstraint)
            self.imageAspectConstraint.isActive = true
        }

        guard let imageView = imagePreview else { return }
        self.imageAspectConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: aspectRatio)
        self.imageAspectConstraint.priority = UILayoutPriority(990)
    }

    private func updateWidthConstraint() {
        let imageInfoWidth = CGFloat(imageInfo?.getWidth() ?? 150)
        imageWidthConstraint.constant = imageInfoWidth
        imageWidthConstraint.priority = UILayoutPriority(900)
    }

    private func setupImageTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        self.imagePreview?.gestureRecognizers = nil
        self.imagePreview?.addGestureRecognizer(gesture)
    }
}
