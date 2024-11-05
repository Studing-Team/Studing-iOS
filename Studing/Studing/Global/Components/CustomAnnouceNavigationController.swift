//
//  CustomAnnouceNavigationController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/30/24.
//

import UIKit

import SnapKit
import Then

enum NavigationType {
    case home
    case announce
}

final class CustomAnnouceNavigationController: UINavigationController {
    
     // MARK: - Properties
    
    private let navigationHeight: CGFloat = 60
     private var currentType: NavigationType = .home
    
    // UI 업데이트를 담당하는 별도 메서드
    private func updateNavigationUI(isHidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.hideDefaultNavigationBar()
            self.safeAreaView.isHidden = isHidden
            self.customNavigationBar.isHidden = isHidden
            self.setupSafeArea(navigationBarHidden: isHidden)
        }
    }
    
    override var isNavigationBarHidden: Bool {
        didSet {
            // UI 업데이트를 별도 메서드로 분리
            updateNavigationUI(isHidden: isNavigationBarHidden)
        }
    }
     
     // MARK: - UI Properties
    
     private let customNavigationBar = UIView()
     private let leftButton = UIButton()
     private let titleLabel = UILabel()
     private let safeAreaView: UIView = UIView()
     
     // MARK: - Life Cycle
     override func viewDidLoad() {
         super.viewDidLoad()
         navigationBar.isHidden = true
         
         setupStyle()
         setupHierarchy()
         setupLayout()
     }
 }

 private extension CustomAnnouceNavigationController {
     
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

     func setupStyle() {
         customNavigationBar.do {
             $0.backgroundColor = .clear
         }
         
         titleLabel.do {
             $0.font = .interSubtitle1()
             $0.textColor = .black50
         }
         
         leftButton.do {
             $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
             $0.tintColor = .black50
             $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
         }
     }
     
     func setupHierarchy() {
         view.addSubviews(safeAreaView, customNavigationBar)
         customNavigationBar.addSubviews(leftButton, titleLabel)
     }
     
     func setupLayout() {
         safeAreaView.snp.makeConstraints {
             $0.bottom.equalTo(view.snp.topMargin)
             $0.horizontalEdges.equalToSuperview()
             $0.height.equalTo(navigationHeight)
         }
         
         customNavigationBar.snp.makeConstraints {
             $0.top.equalTo(view.safeAreaLayoutGuide)
             $0.leading.trailing.equalToSuperview()
//             $0.height.equalTo(49)
         }
         
         leftButton.snp.makeConstraints {
             $0.leading.equalToSuperview().offset(16)
             $0.bottom.equalToSuperview().offset(-8)
             $0.size.equalTo(24)
         }
         
         titleLabel.snp.makeConstraints {
             $0.leading.equalTo(leftButton.snp.trailing).offset(10)
             $0.centerY.equalTo(leftButton)
         }
     }
     
//     func updateNavigationVisibility() {
//         switch currentType {
//         case .home:
//             customNavigationBar.isHidden = true
//         case .announce:
//             customNavigationBar.isHidden = false
//         }
//     }
     
     @objc private func backButtonTapped() {
         popViewController(animated: true)
     }
 }

 // MARK: - Public Methods
 extension CustomAnnouceNavigationController {
     func setNavigationType(_ type: NavigationType) {
         currentType = type
     }
     
     func setNavigationTitle(_ title: String) {
         titleLabel.text = title
     }
 }
