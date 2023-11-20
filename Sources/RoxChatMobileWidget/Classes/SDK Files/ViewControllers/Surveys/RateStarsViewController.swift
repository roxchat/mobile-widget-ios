//
//  RateStarsViewController.swift
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

import AVFoundation
import Cosmos
import UIKit

protocol RateStarsViewControllerDelegate: AnyObject {
    
    func rateOperator(operatorID: String, rating: Int)
}

class RateStarsViewController: WMSurveyViewController {
    
    // MARK: - Init Properties
    weak var rateOperatorDelegate: RateStarsViewControllerDelegate?
    var operatorId = String()
    var operatorRating = 0.0
    var currentRating = 0.0
    var isSurvey = false
    var descriptionText: String?
    var config: WMSurveyViewConfig?

    // MARK: - IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var containerView: UIView!

    @IBOutlet var containerHeight: NSLayoutConstraint!
    @IBOutlet var containerWidth: NSLayoutConstraint!
    
    // MARK: - Subviews
    private var cosmosRatingView: CosmosView = RateStarsViewController.produceCosmosView()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        adjustConfig()
    }

    @IBAction func sendRate(_ sender: Any) {
        let rating = Int(operatorRating)

        if isSurvey {
            self.delegate?.sendSurveyAnswer("\(rating)")
        } else {
            self.rateOperatorDelegate?.rateOperator(operatorID: self.operatorId, rating: rating)
        }
        self.closeViewController()
    }

    private func adjustConfig() {
        if let settings = config?.cosmosSettings {
            cosmosRatingView.settings = settings
        }

        if let title = config?.title {
            titleLabel.attributedText = title
        }

        if let subtitle = config?.subtitle {
            descriptionLabel.attributedText = subtitle
        }

        if let sendButtonColor = config?.buttonColor {
            sendButton.backgroundColor = sendButtonColor
        }

        if let starsViewSize = config?.starsViewSize {
            containerWidth.constant = starsViewSize.width
            containerHeight.constant = starsViewSize.height
        }

        if let buttonTitle = config?.buttonTitle {
            sendButton.setAttributedTitle(buttonTitle, for: .normal)
        }

        if let buttonCornerRadius = config?.buttonCornerRadius {
            sendButton.layer.cornerRadius = buttonCornerRadius
        }
    }

    private func setupSubviews() {
        if isSurvey {
            titleLabel.alpha = 0
        }
        descriptionLabel.text = isSurvey ? descriptionText : "Please rate the overall impression of the consultation".localized

        disableSendButton()
        cosmosRatingView.rating = currentRating
        let changeRateEnabled = operatorRating != 0.0 ? self.config?.changeRateEnabled != false : true
        
        cosmosRatingView.didFinishTouchingCosmos = { (rating) -> Void in
            if self.currentRating != rating && changeRateEnabled {
                self.operatorRating = rating
                self.enableSendButton()
            } else {
                self.disableSendButton()
            }
        }
        containerView.addSubview(cosmosRatingView)
        cosmosRatingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private static func produceCosmosView(with settings: CosmosSettings? = nil) -> CosmosView {
        let cosmosView = CosmosView()
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        if let settings = settings {
            cosmosView.settings = settings
        } else {
            cosmosView.settings = RateStarsViewController.produceDefaultCosmosSettings()
        }
        return cosmosView
    }

    private static func produceDefaultCosmosSettings() -> CosmosSettings {
        var settings = CosmosSettings()
        settings.fillMode = .full
        settings.starSize = 30
        settings.filledColor = cosmosViewFilledColour
        settings.filledBorderColor = cosmosViewFilledBorderColour
        settings.emptyColor = cosmosViewEmptyColour
        settings.emptyBorderColor = cosmosViewEmptyBorderColour
        settings.emptyBorderWidth = 2
        return settings
    }
}
