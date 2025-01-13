//
//  CheckBoxButton.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/10/24.
//

import UIKit

enum CheckBoxState {
    case checked
    case unchecked
    
    var backgroundColor: UIColor {
        switch self {
        case .checked:
            return .primary50
        case .unchecked:
            return .white
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .checked:
            return .primary50
        case .unchecked:
            return .black30
        }
    }
}

final class CheckBoxButton: UIButton {
    
    var onTap: ((CheckBoxState) -> Void)?
    
    private let checkedImageView = UIImageView()
    private let backgroundView = UIView()
    
    var checkBoxState: CheckBoxState = .unchecked {
        didSet {
            updateButtonUI()
        }
    }
    
    init(state: CheckBoxState = .unchecked) {
        self.checkBoxState = state
        super.init(frame: .zero)
        
        setupButton()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateButtonState(_ isSeleted: Bool) {
        if isSeleted == false {
            checkBoxState = .unchecked
        } else {
            checkBoxState = .checked
        }
    }
}

extension CheckBoxButton {
    private func updateButtonUI() {
        var config = self.configuration
        
        config?.background.backgroundColor = checkBoxState.backgroundColor
        config?.background.strokeColor = checkBoxState.borderColor
        config?.image = checkBoxState == .checked ? UIImage(named: "check") : nil
        
        self.configuration = config
    }
    
    private func setupButton() {
        var config = UIButton.Configuration.plain()
        
        config.background.backgroundColor = checkBoxState.backgroundColor
        config.background.strokeColor = checkBoxState.borderColor
        config.background.strokeWidth = 1
        config.cornerStyle = .small
        
        let checkmarkImage = UIImage(named: "check")
        config.image = checkBoxState == .checked ? checkmarkImage : nil
        config.imagePlacement = .all
        config.imagePadding = 10
        
        self.configuration = config
    }
    
    private func setupAction() {
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        // 상태를 토글하고 이벤트 전달
        checkBoxState = checkBoxState == .checked ? .unchecked : .checked
        onTap?(checkBoxState)  // 현재 상태를 함께 전달
    }
}
