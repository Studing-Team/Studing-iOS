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
    private let logoImage = UIImageView()
    private let pushMainHomeButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Push SuccessSignUpViewController")
        
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
        }
        
        pushMainHomeButton.do {
            $0.setTitle(StringLiterals.Button.pushMainHomeTitle, for: .normal)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(successTitleLabel, logoImage, pushMainHomeButton)
    }
    
    func setupLayout() {
        successTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.convertByHeightRatio(256))
        }
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(successTitleLabel.snp.bottom).offset(35)
        }
        
        pushMainHomeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(19)
            $0.bottom.equalToSuperview().offset(view.convertByHeightRatio(-35))
        }
    }
    
    func setupDelegate() {
        
    }
}
