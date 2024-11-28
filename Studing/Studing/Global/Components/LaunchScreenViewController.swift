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
    
    // MARK: - init
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // LaunchScreen을 일정 시간 동안 표시한 후 로그인 플로우로 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.checkUserAuth()
        }
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
            $0.font = .montserratAlternatesExtraBold(size: 34)
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
            $0.top.equalTo(subTitleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
    func checkUserAuth() {
        let mypageUseCase = MypageUseCase(repository: HomeRepositoryImpl())
        
        Task {
            let result = await mypageUseCase.execute()
            switch result {
            case .success(let response):
                let entity = response.toEntity()
                
                KeychainManager.shared.saveData(key: .userAuthState, value: entity.role.rawValue)
                
                await MainActor.run {
                    pushNextViewForLogin()
                }
                
            case .failure:
                print("토큰 또는 API 에러 발생으로 인해 로그인 화면으로 이동")
                await MainActor.run {
                    UserDefaults.standard.set(false, forKey: "isLogined")
                    self.coordinator?.removeLaunchScreenAndShowLoginFlow()
                }
            }
        }
    }
    
    func pushNextViewForLogin() {
        let isLogined = UserDefaults.standard.bool(forKey: "isLogined")
        
        if isLogined == true {
            print("로그인 되어 있음")
            self.coordinator?.showTabBarFlow()
        } else {
            print("로그인 되어 있지 않음")
            self.coordinator?.removeLaunchScreenAndShowLoginFlow()
        }
    }
}
