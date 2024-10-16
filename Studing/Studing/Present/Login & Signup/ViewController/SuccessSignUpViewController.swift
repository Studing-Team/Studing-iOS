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
    private let mainHomeButton = CustomButton(buttonStyle: .showStudingHome)
    
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
        
        logoImage.do {
            $0.image = UIImage(resource: .splashLogo)
        }
        
        mainHomeButton.do {
            $0.layer.borderColor = UIColor.black10.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 25.0
            $0.clipsToBounds = true
        }
        
        studingTitleLabel.do {
            $0.text = "Studing"
            $0.textColor = .white
            $0.font = .montserratExtraBold(size: 34)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(successTitleLabel, successSubTitleLabel, logoImage, studingTitleLabel, mainHomeButton)
    }
    
    func setupLayout() {
        successTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(198))
            $0.centerX.equalToSuperview()
        }
        
        successSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(successTitleLabel.snp.bottom).offset(view.convertByHeightRatio(10))
            $0.centerX.equalToSuperview()
        }
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(successSubTitleLabel.snp.bottom).offset(view.convertByHeightRatio(38))
            $0.centerX.equalToSuperview()
        }
        
        studingTitleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(view.convertByHeightRatio(30))
            $0.centerX.equalToSuperview()
        }
        
        mainHomeButton.snp.makeConstraints {
            $0.top.equalTo(studingTitleLabel.snp.bottom).offset(view.convertByHeightRatio(150))
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(19)
            $0.height.equalTo(60)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-4)
        }
    }
    
    func setupDelegate() {
        
    }
}
