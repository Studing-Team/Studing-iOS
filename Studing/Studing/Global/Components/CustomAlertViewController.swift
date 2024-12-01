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
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private let centerButton = UIButton()
    
    private let alertBackgroundView = UIView()
    private let titleStackView = UIStackView()
    private let bottomStackView = UIStackView()
    
    // MARK: - Init
    
    // 확인, 취소 버튼이 있는 Alert
    init(alertType: AlertType,
         mainTitle: String,
         subTitle: String,
         rightButtonTitle: String,
         leftButtonTitle: String,
         leftButtonHandler: ButtonAction?,
         rightButtonHandler: ButtonAction?) {
        self.alertType = alertType
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.rightButtonTitle = rightButtonTitle
        self.leftButtonTitle = leftButtonTitle
        self.leftButtonHandler = leftButtonHandler
        self.rightButtonHandler = rightButtonHandler
        self.centerButtonHandler = nil
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // 확인 버튼이 있는 Alert
    init(alertType: AlertType,
         mainTitle: String,
         subTitle: String,
         confirmTitle: String,
         centerButtonHandler: ButtonAction?) {
        self.alertType = alertType
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.rightButtonTitle = confirmTitle
        self.leftButtonTitle = nil
        self.leftButtonHandler = nil
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
        
        leftButton.do {
            $0.setTitle(leftButtonTitle, for: .normal) // 버튼의 제목 설정
            $0.setTitleColor(.white, for: .normal) // 제목 색상 설정
            $0.titleLabel?.font = .interSubtitle2() // 폰트 설정
            $0.backgroundColor = .black20 // 배경색 설정
            $0.layer.cornerRadius = 8
        }
        
        rightButton.do {
            $0.setTitle(rightButtonTitle, for: .normal) // 버튼의 제목 설정
            $0.setTitleColor(.white, for: .normal) // 제목 색상 설정
            $0.titleLabel?.font = .interSubtitle2() // 폰트 설정
            $0.backgroundColor = .primary50 // 배경색 설정
            $0.layer.cornerRadius = 8
        }
        
        centerButton.do {
            $0.setTitle(rightButtonTitle, for: .normal) // 버튼의 제목 설정
            $0.setTitleColor(.white, for: .normal) // 제목 색상 설정
            $0.titleLabel?.font = .interSubtitle2() // 폰트 설정
            $0.backgroundColor = .primary50 // 배경색 설정
            $0.layer.cornerRadius = 8
        }
    }
    
    func setupHierarchy() {
        
        view.addSubviews(alertBackgroundView)
        alertBackgroundView.addSubviews(titleStackView, bottomStackView)
        
        titleStackView.addArrangedSubviews(mainTitleLabel, subTitleLabel)
        
        switch alertType {
        case .confirmCancel:
            bottomStackView.addArrangedSubviews(leftButton, rightButton)
            
        case .onlyConfirm:
            bottomStackView.addArrangedSubview(centerButton)
        }
    }
    
    func setupLayout() {
        alertBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(38)
            $0.height.equalTo(175)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(38)
        }
        
        [leftButton, rightButton, centerButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(38)
            }
        }
    }
    
    func setupDelegate() {
        
    }
    
    func setupButtonAction() {
        leftButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        centerButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        switch sender {
        case leftButton: leftButtonHandler?() ?? cancelAction()
        case rightButton: rightButtonHandler?() ?? cancelAction()
        case centerButton: centerButtonHandler?() ?? cancelAction()
        default: break
        }
    }
    
    func cancelAction() {
        dismiss(animated: false)
    }
}
