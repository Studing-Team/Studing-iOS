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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


//    init() {
//        super.init(frame: .zero)
//        setupStyle()
//        setupHierarchy()
//        setupLayout()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
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
//    func setupStyle() {
//        backgroundView.do {
//            $0.backgroundColor = .white
//            $0.layer.borderWidth = 1
//            $0.layer.borderColor = UIColor.black30.cgColor
//            $0.layer.cornerRadius = 2
//        }
//        
//        checkedImageView.do {
//            $0.image = UIImage(systemName: "checkmark")
//            $0.tintColor = .white
//        }
//    }
//    
//    func setupHierarchy() {
//        addSubviews(backgroundView)
//        backgroundView.addSubview(checkedImageView)
//    }
//    
//    func setupLayout() {
//        backgroundView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//            $0.width.equalTo(convertByWidthRatio(20))
//            $0.height.equalTo(convertByHeightRatio(20))
//        }
//        
//        checkedImageView.snp.makeConstraints {
//            $0.center.equalToSuperview()
//        }
//    }
}
