//
//  ProcessingPersonalData.swift
//  RoxChatMobileWidget
//
//

import Foundation
import UIKit
import RoxchatClientLibrary

class ProcessingPersonalData: UIViewController {
    
    @IBOutlet weak var checkbox: CheckboxButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var agreementText: UITextView!
    
    var agreementUrlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupButtons()
    }
    
    func setupLabels() {
        titleLabel.text = "Agreement Title".localized
        let linkString = "Agreement link".localized
        let agreementString = "Agreement".localized
        let fullString = agreementString + " " + linkString
        let attributedString = NSMutableAttributedString(string: fullString)
        let baseFont = UIFont.systemFont(ofSize: 14)
        attributedString.addAttribute(.font, value: baseFont, range: NSRange(location: 0, length: fullString.count))
        attributedString.addAttribute(.foregroundColor, value: buttonBorderColor, range: NSRange(location: 0, length: fullString.count))
        
        if let range = fullString.range(of: linkString) {
            let nsRange = NSRange(range, in: fullString)
            attributedString.addAttribute(.link, value: agreementUrlString, range: nsRange)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: nsRange)
        }
        
        agreementText.attributedText = attributedString
    }
    
    func setupButtons() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                         target: self,
                                         action: #selector(tapBackButton))
                
        let doneButton = UIBarButtonItem(title: "Start chat".localized,
                                         style: .done,
                                         target: self,
                                         action: #selector(goToChat))
                
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc
    func tapBackButton() {
        navigationController?.popToRootViewController(animated: false)
        RoxchatServiceController.shared.stopSession()
    }
    
    @IBAction func tapCheckmark(_ sender: Any) {
        navigationItem.rightBarButtonItem?.isEnabled = checkbox.buttonState == .checked
    }
    
    @objc
    func goToChat() {
        navigationController?.popViewController(animated: true)
    }
}
