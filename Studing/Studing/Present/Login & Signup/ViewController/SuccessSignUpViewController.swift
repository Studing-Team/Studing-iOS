//
//  SuccessSignUpViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import UIKit

import SnapKit
import Then

final class SuccessSignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let successTitleLabel = UILabel()
    private let successSubTitleLabel = UILabel()
    private let logoImage = UIImageView()
    private let studingTitleLabel = UILabel()
    private let pushMainHomeButton = CustomButton(buttonStyle: .showStuding)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Push SuccessSignUpViewController")
        
        view.applyGradient(colors: [.loginStartGradient, .loginEndGradient], direction: .topRightToBottomLeft, locations: [-0.2, 1.3])
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Pop SuccessSignUpViewController")
    }
}

// MARK: - Private Extensions

private extension SuccessSignUpViewController {
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupStyle() {
        successTitleLabel.do {
            $0.text = StringLiterals.Authentication.successSignUpTitle
            $0.textColor = .white
            $0.font = .interHeadline2()
        }
        
        successSubTitleLabel.do {
            $0.text = StringLiterals.Authentication.successSignUpSubTitle
            $0.textColor = .white
            $0.font = .interBody1()
        }
        
        pushMainHomeButton.do {
            $0.setTitle(StringLiterals.Button.pushMainHomeTitle, for: .normal)
        }
        
        studingTitleLabel.do {
            $0.text = "Studing"
            $0.textColor = .white
            $0.font = .montserratExtraBold(size: 34)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(successTitleLabel, logoImage, pushMainHomeButton)
    }
    
    func setupLayout() {
        successTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.convertByHeightRatio(256))
        }
        
        successSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(successSubTitleLabel.snp.bottom).offset(10)
        }
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(successSubTitleLabel.snp.bottom).offset(38)
        }
        
        pushMainHomeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(19)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().offset(view.convertByHeightRatio(-35))
        }
    }
    
    func setupDelegate() {
        
    }
}
