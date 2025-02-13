//
//  CustomAlertViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/21/24.
//

import UIKit

import SnapKit
import Then

enum AlertType {
    case onlyConfirm
    case confirmCancel
}

final class CustomAlertViewController: UIViewController {
    
    // MARK: - Properties
    
    typealias ButtonAction = () -> Void
    
    private var alertType: AlertType
    private var mainTitle: String?
    private var subTitle: String?
    private var rightButtonTitle: String?
    private var leftButtonTitle: String?
    private var leftButtonHandler: ButtonAction?
    private var rightButtonHandler: ButtonAction?
    private var centerButtonHandler: ButtonAction?
    
    // MARK: - UI Properties
    
    private let mainTitleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let leftButton: CustomButton?
    private let rightButton: CustomButton?
    private let centerButton: CustomButton?
    
    private let alertBackgroundView = UIView()
    private let titleStackView = UIStackView()
    private let bottomStackView = UIStackView()
    
    // MARK: - Init
    
    // 확인, 취소 버튼이 있는 Alert
    init(alertType: AlertType,
         mainTitle: String,
         subTitle: String,
         leftButtonStyle: ButtonStyle,
         rightButtonStyle: ButtonStyle,
         leftButtonHandler: ButtonAction?,
         rightButtonHandler: ButtonAction?) {
        self.alertType = alertType
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        
        self.leftButton = CustomButton(buttonStyle: leftButtonStyle)
        self.rightButton = CustomButton(buttonStyle: rightButtonStyle)
        self.centerButton = nil
        
        self.leftButtonHandler = leftButtonHandler
        self.rightButtonHandler = rightButtonHandler
        self.centerButtonHandler = nil
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // 확인 버튼이 있는 Alert
    init(alertType: AlertType,
         mainTitle: String,
         subTitle: String,
         centerButtonStyle: ButtonStyle,
         centerButtonHandler: ButtonAction?) {
        self.alertType = alertType
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        
        self.centerButton = CustomButton(buttonStyle: centerButtonStyle)
        
        self.leftButton = nil
        self.rightButton = nil
        self.rightButtonHandler = nil
        self.centerButtonHandler = centerButtonHandler
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.65)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelBackgroundAction)))
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupButtonAction()
    }
}

// MARK: - Private Extensions

private extension CustomAlertViewController {
    func setupStyle() {
        
        alertBackgroundView.do {
            $0.backgroundColor = .black5
            $0.layer.cornerRadius = 20
        }
        
        bottomStackView.do {
            $0.axis = .horizontal
            $0.spacing = alertType == .confirmCancel ? 10 : 0
            $0.distribution = .fillEqually
        }
        
        titleStackView.do {
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .fillProportionally
        }
        
        mainTitleLabel.do {
            $0.text = mainTitle
            $0.numberOfLines = 0
            $0.textColor = .black50
            $0.font = .interSubtitle1()
            $0.textAlignment = .center
        }
        
        subTitleLabel.do {
            $0.text = subTitle
            $0.textColor = .black30
            $0.numberOfLines = 2
            $0.font = .interBody1()
            $0.textAlignment = .center
        }
    }
    
    func setupHierarchy() {
        
        view.addSubviews(alertBackgroundView)
        alertBackgroundView.addSubviews(titleStackView, bottomStackView)
        
        titleStackView.addArrangedSubviews(mainTitleLabel, subTitleLabel)
        
        switch alertType {
        case .confirmCancel:
            
            guard let leftButton, let rightButton else { return }
            
            bottomStackView.addArrangedSubviews(leftButton, rightButton)
            
        case .onlyConfirm:
            
            guard let centerButton else { return }
            
            bottomStackView.addArrangedSubview(centerButton)
        }
    }
    
    func setupLayout() {
        alertBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(38)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        bottomStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(38)
        }
        
        [leftButton, rightButton, centerButton].forEach {
            $0?.snp.makeConstraints {
                $0.height.equalTo(38)
            }
        }
    }
    
    func setupDelegate() {
        
    }
    
    func setupButtonAction() {
        switch alertType {
        case .confirmCancel:
            leftButton?.buttonAction = leftButtonHandler ?? cancelButtonAction
            rightButton?.buttonAction = rightButtonHandler ?? cancelButtonAction
            
        case .onlyConfirm:
            centerButton?.buttonAction = centerButtonHandler ?? cancelButtonAction
        }
    }
    
    @objc func cancelBackgroundAction() {
        dismiss(animated: false)
    }
    
    func cancelButtonAction() {
        dismiss(animated: false)
    }
}
