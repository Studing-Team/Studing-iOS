//
//  AllReadAnnounceViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/28/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class AllReadAnnounceViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var coordinator: HomeCoordinator?
    
    // MARK: - UI Properties
    
    private let completeImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let backHomeButton = CustomButton(buttonStyle: .home)
    
    // MARK: - init
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black5
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let customNavController = self.navigationController as? CustomAnnouceNavigationController {
            customNavController.setNavigationType(.unReadToHome)
//            customNavController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

// MARK: - Private Extensions

private extension AllReadAnnounceViewController {
    func setupStyle() {
        completeImageView.do {
            $0.image = UIImage(resource: .summit)
        }
        
        titleLabel.do {
            $0.text = "놓친 공지사항을 모두 확인했어요!"
            $0.font = .interSubtitle2()
            $0.textColor = .black50
        }
        
        subTitleLabel.do {
            $0.text = "홈으로 돌아가서 더 많은 공지를 살펴봐요."
            $0.font = .interCaption12()
            $0.textColor = .black30
        }
        
        backHomeButton.do {
            $0.addTarget(self, action: #selector(backToHome), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(completeImageView, titleLabel, subTitleLabel, backHomeButton)
    }
    
    func setupLayout() {
        completeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(view.convertByHeightRatio(332))
            $0.centerX.equalToSuperview()
            $0.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(completeImageView.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        backHomeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(34)
            $0.height.equalTo(48)
        }
    }
    
    @objc private func backToHome() {
        self.coordinator?.popToHome()
    }
    
    func setupDelegate() {
        
    }
}
