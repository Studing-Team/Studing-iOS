//
//  LaunchScreenViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/20/24.
//

import UIKit

import SnapKit
import Then

final class LaunchScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var coordinator: AppCoordinator?
    
    // MARK: - UI Properties
    
    private let studingLogin = UIImageView()
    private let subTitleLabel = UILabel()
    private let studingTitleLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
}

// MARK: - Private Extensions

private extension LaunchScreenViewController {
    func setupStyle() {
        self.navigationController?.isNavigationBarHidden = true
        view.applyGradient(colors: [.loginStartGradient, .loginEndGradient], direction: .topRightToBottomLeft, locations: [-0.2, 1.3])
        
        studingLogin.do {
            $0.image = .splashLogo
        }
        
        subTitleLabel.do {
            $0.text = "대학생의 모든 것을 담은,"
            $0.textColor = .white
            $0.font = .interBody1()
        }
        
        studingTitleLabel.do {
            $0.text = "Studing"
            $0.textColor = .white
            $0.font = .montserratExtraBold(size: 34)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(studingLogin, subTitleLabel, studingTitleLabel)
    }
    
    func setupLayout() {
        studingLogin.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.convertByHeightRatio(284))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(view.convertByWidthRatio(132.75))
            $0.height.equalTo(view.convertByHeightRatio(155))
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(studingLogin.snp.bottom).offset(view.convertByHeightRatio(30))
            $0.centerX.equalToSuperview()
        }
        
        studingTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(view.convertByHeightRatio(-284))
        }
    }
}
