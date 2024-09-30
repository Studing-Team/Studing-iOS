//
//  CustomSignUpNavigationController.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/25/24.
//

import UIKit

import SnapKit
import Then

enum LeftButtonType {
    case xmark
    case arrow
}

final class CustomSignUpNavigationController: UINavigationController {
    
    // MARK: - Properties
    private var isPopping = false
    private let navigationHeight: CGFloat = 60
    private var signUpStepCount = 1 {
        didSet {
            if signUpStepCount - 1 <= 0 {
                signUpStepCount = 1
            }
        }
    }
    private var leftButtonType: LeftButtonType = .xmark
    private var progressBarWidth: CGFloat = 150
    
    override var isNavigationBarHidden: Bool {
        didSet {
            hideDefaultNavigationBar()
            safeAreaView.isHidden = isNavigationBarHidden
            customNavigationBar.isHidden = isNavigationBarHidden
            setupSafeArea(navigationBarHidden: isNavigationBarHidden)
        }
    }
    
    // MARK: - UI Properties
    
    private let customNavigationBar: UIView = UINavigationBar()
    private let safeAreaView: UIView = UIView()
    private let leftButton = UIButton()
    private let naviTitleLabel = UILabel()
    private let dividerView = UIView()
    private let progressbarView = UIView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressbarView.applyGradient(colors: [.loginEndGradient, .loginStartGradient], direction: .leftToRight, locations: [0, 1.0])
        progressbarView.layer.cornerRadius = 2
    }
    
    /// DefaultNavigationBar를 hidden 시켜주는 함수
    func hideDefaultNavigationBar() {
        navigationBar.isHidden = true
    }
    
    /// navigationBar가 hidden 상태인지 아닌지에 따라 view의 safeArea를 정해주는 함수
    func setupSafeArea(navigationBarHidden: Bool) {
        if navigationBarHidden {
            additionalSafeAreaInsets = UIEdgeInsets(top: 0,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)
        } else {
            additionalSafeAreaInsets = UIEdgeInsets(top: navigationHeight,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)
        }
    }
    
    func changeLeftButtonType(_ leftButtonType: LeftButtonType) {
        self.leftButtonType = leftButtonType
        updateLeftButtonImage()
    }
    
    private func updateLeftButtonImage() {
        let imageName = signUpStepCount == 1 ? "xmark" : "chevron.left"
        leftButton.setImage(UIImage(systemName: imageName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)), for: .normal)
    }
    
    private func updateProgressBar() {
        let newWidth = SizeLiterals.Screen.screenWidth * CGFloat(signUpStepCount) / 6.0
        print(newWidth)
        
        progressbarView.snp.remakeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(newWidth)
        }
            
        UIView.animate(withDuration: 0.3) {
            print("\(self.signUpStepCount) 진행 중")
            self.view.layoutIfNeeded()
        }
    }
    
    func changeSignUpStep(count: Int) {
        self.signUpStepCount = count
        updateLeftButtonImage()
        updateProgressBar()
    }
}

// MARK: - Private Extensions

private extension CustomSignUpNavigationController {
    func setupStyle() {
        customNavigationBar.do {
            $0.backgroundColor = .black5
        }
        
        safeAreaView.do {
            $0.backgroundColor = customNavigationBar.backgroundColor
        }
        
        naviTitleLabel.do {
            $0.text = "회원가입"
            $0.font = .interSubtitle1()
        }
        
        dividerView.do {
            $0.backgroundColor = .black10
        }
        
        leftButton.do {
            $0.setImage(UIImage(systemName: leftButtonType == .xmark ? "xmark" : "chevron.left")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)), for: .normal)
            $0.tintColor = .black50
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }

        progressbarView.do {
            $0.applyGradient(colors: [.loginEndGradient, .loginStartGradient], direction: .leftToRight, locations: [0, 1.0])
            $0.layer.cornerRadius = 2
        }
    }
    
    @objc func backButtonTapped() {
        popViewController(animated: true)
        signUpStepCount -= 1
        updateProgressBar()
        
        if signUpStepCount == 1 {
            updateLeftButtonImage()
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(safeAreaView, customNavigationBar)
        
        customNavigationBar.addSubviews(leftButton, naviTitleLabel, dividerView, progressbarView)
    }
    
    func setupLayout() {
        customNavigationBar.snp.makeConstraints {
            $0.height.equalTo(navigationHeight)
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
        }
        
        safeAreaView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
        }

        leftButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        naviTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        progressbarView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(SizeLiterals.Screen.screenWidth * CGFloat(signUpStepCount) / 6.0)
            $0.height.equalTo(4)
        }
    }
    
    func setupDelegate() {

    }
}