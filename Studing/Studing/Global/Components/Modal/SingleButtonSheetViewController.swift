//
//  SingleButtonSheetViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/12/25.
//

import UIKit

import SnapKit
import Then

class SingleButtonSheetViewController: BaseSheetViewController {
    
    // MARK: - Properties
    
    private var bottomButtonAction: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let bottomButton: CustomButton
    
    // MARK: - Init
    
    init(buttonStyle: ButtonStyle, action: (() -> Void)? = nil) {
        self.bottomButton = CustomButton(buttonStyle: buttonStyle)
        self.bottomButtonAction = action
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
    
    func bindingBottomButtonAction(action: (() -> Void)?) {
        bottomButtonAction = action
    }
}

// MARK: - Private Extensions

private extension SingleButtonSheetViewController {
    func setupStyle() {
        bottomButton.do {
            $0.buttonAction = {
                self.bottomButtonAction?()
            }
        }
    }
    
    func setupHierarchy() {
        self.containerView.addSubview(bottomButton)
    }
    
    func setupLayout() {
        bottomButton.snp.makeConstraints {
            $0.top.equalTo(contentAreaView.snp.bottom)//.offset(view.convertByHeightRatio(40))
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(18)
            $0.height.equalTo(49)
        }
    }
    
    func setupDelegate() {
        
    }
}


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
    }
    
    func setupHierarchy() {
        contentAreaView.addSubview(bottomButtonStackView)
    }
    
    func setupLayout() {
        bottomButtonStackView.snp.makeConstraints {
//            $0.top.equalTo(contentAreaView.snp.bottom).offset(view.convertByHeightRatio(40))
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
