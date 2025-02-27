//
//  SingleButtonConfiguration.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/17/25.
//

import UIKit

import SnapKit
import Then

final class SingleButtonConfiguration: SheetButtonsConfigurable {
    
    // MARK: - SheetButtonsConfigurable Properties
    
    let buttonContainerView = UIView()
    var buttonHeight: CGFloat { return 85 }
    
    // MARK: - UI Properties
    
    private let button: CustomButton
    
    // MARK: - Button Action Properties
    
    private var buttonAction: (() -> Void)?
    
    // MARK: - Init
    
    init(buttonStyle: ButtonStyle) {
        self.button = CustomButton(buttonStyle: buttonStyle)
    }
    
    func setAction(_ action: @escaping () -> Void) {
        self.buttonAction = action
        setupActions()
    }
    
    func setupButtons() {
        setupHierarchy()
        setupLayout()
    }
    
    private func setupActions() {
        button.buttonAction = { [weak self] in
            self?.buttonAction?()
        }
    }
}

// MARK: - Private Extensions

private extension SingleButtonConfiguration {
    func setupHierarchy() {
        buttonContainerView.addSubview(button)
    }
    
    func setupLayout() {
        button.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(18)
            $0.height.equalTo(49)
        }
    }
}
