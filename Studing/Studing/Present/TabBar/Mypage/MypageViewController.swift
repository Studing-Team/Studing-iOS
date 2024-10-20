//
//  MypageViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class MypageViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let studingHeaderView = StudingHeaderView(type: .mypage)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
}

// MARK: - Private Extensions

private extension MypageViewController {
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupStyle() {
        view.applyGradient(colors: [.loginStartGradient.withFigmaStyleAlpha(0.3), .loginEndGradient.withFigmaStyleAlpha(0.3)], direction: .topToBottom, locations: [0, 1])
        
    }
    
    func setupHierarchy() {
        view.addSubviews(studingHeaderView)
    }
    
    func setupLayout() {
        studingHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
    
    func setupDelegate() {
        
    }
}
