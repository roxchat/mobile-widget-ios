//
//  CheckboxButton.swift
//  RoxChatMobileWidget
//

import UIKit

class CheckboxButton: UIButton {
    
    enum State {
        case checked
        case unchecked
    }
    
    private(set) var buttonState: State = .unchecked {
        didSet {
            updateAppearance()
        }
    }
    
    var checkedImage: UIImage? = UIImage(systemName: "checkmark.square.fill") {
        didSet { updateAppearance() }
    }
    
    var uncheckedImage: UIImage? = UIImage(systemName: "square") {
        didSet { updateAppearance() }
    }
    
    var checkedTintColor: UIColor = buttonBorderColor {
        didSet { updateAppearance() }
    }
    
    var uncheckedTintColor: UIColor = .gray {
        didSet { updateAppearance() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        setTitle("", for: .normal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        updateAppearance()
    }
    
    private func updateAppearance() {
        switch buttonState {
        case .checked:
            setImage(checkedImage, for: .normal)
            tintColor = checkedTintColor
        case .unchecked:
            setImage(uncheckedImage, for: .normal)
            tintColor = uncheckedTintColor
        }
    }
    
    func toggle() {
        buttonState = (buttonState == .checked) ? .unchecked : .checked
    }
    
    func setState(_ state: State, animated: Bool = false) {
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.buttonState = state
            }
        } else {
            buttonState = state
        }
    }
    
    @objc private func buttonTapped() {
        toggle()
    }
}
