//
//  DoubleButtonSheetViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/24/25.
//

import UIKit

import SnapKit
import Then

class DoubleButtonSheetViewController: BaseSheetViewController {
    
    // MARK: - Properties
    
    private var leftButtonAction: (() -> Void)?
    private var rightButtonAction: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let bottomButtonStackView = UIStackView()
    private let leftButton: CustomButton
    private let rightButton: CustomButton
    
    // MARK: - Init
    
    init(
        leftButtonStyle: ButtonStyle,
        rightButtonStyle: ButtonStyle,
        leftAction: (() -> Void)? = nil,
        rightAction: (() -> Void)? = nil
    ) {
        self.leftButton = CustomButton(buttonStyle: leftButtonStyle)
        self.rightButton = CustomButton(buttonStyle: rightButtonStyle)
        self.leftButtonAction = leftAction
        self.rightButtonAction = rightAction
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    func bindingBottomLeftButtonAction(action: (() -> Void)?) {
        leftButtonAction = action
    }
    
    func bindingBottomRightButtonAction(action: (() -> Void)?) {
        rightButtonAction = action
    }
}

// MARK: - Private Extensions

private extension DoubleButtonSheetViewController {
    func setupStyle() {
        
        bottomButtonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillProportionally
            $0.addArrangedSubviews(leftButton, rightButton)
        }
        
        leftButton.do {
            $0.buttonAction = {
                self.leftButtonAction?()
            }
        }
        
        rightButton.do {
            $0.buttonAction = {
                self.rightButtonAction?()
            }
        }
    }
    
    func setupHierarchy() {
        contentAreaView.addSubview(bottomButtonStackView)
    }
    
    func setupLayout() {
        bottomButtonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(18)
            $0.height.equalTo(49)
        }
        
        leftButton.snp.makeConstraints {
            $0.width.equalTo(87)
        }
    }
    
    func setupDelegate() {
        
    }
}
