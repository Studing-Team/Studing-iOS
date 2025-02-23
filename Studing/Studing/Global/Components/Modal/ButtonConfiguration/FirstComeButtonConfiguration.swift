//
//  FirstComeButtonConfiguration.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/21/25.
//

import UIKit

import SnapKit
import Then

final class FirstComeButtonConfiguration: SheetButtonsConfigurable {
    
    // MARK: - SheetButtonsConfigurable Properties
    
    let buttonContainerView = UIView()
    var buttonHeight: CGFloat { return 85 }
    
    // MARK: - UI Properties
    
    private let stackView = UIStackView()
    private let closeButton: CustomButton
    private let myRankingButton: CustomButton
    
    // MARK: - Button Action Properties
    
    private var closeAction: (() -> Void)?
    private var myRankingAction: (() -> Void)?
    
    // MARK: - Init
    
    init() {
         self.closeButton = CustomButton(buttonStyle: .close(type: .gray))
         self.myRankingButton = CustomButton(buttonStyle: .myRanking)
     }
     
     func setCloseAction(_ action: @escaping () -> Void) {
         self.closeAction = action
         
         closeButton.buttonAction = { [weak self] in
             self?.closeAction?()
         }
     }
     
     func setMyRankingAction(_ action: @escaping () -> Void) {
         self.myRankingAction = action
         
         myRankingButton.buttonAction = { [weak self] in
             self?.myRankingAction?()
         }
     }
    
    func setupButtons() {
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
}

// MARK: - Private Extensions

private extension FirstComeButtonConfiguration {
    func setupStyle() {
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillProportionally
            $0.addArrangedSubviews(closeButton, myRankingButton)
        }
    }
    
    func setupHierarchy() {
        buttonContainerView.addSubview(stackView)
    }
    
    func setupLayout() {
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(18)
            $0.height.equalTo(49)
        }
        
        closeButton.snp.makeConstraints {
            $0.width.equalTo(87)
        }
    }
}
