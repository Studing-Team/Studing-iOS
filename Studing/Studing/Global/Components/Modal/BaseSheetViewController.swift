//
//  BaseSheetViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/12/25.
//

import UIKit

import SnapKit
import Then

class BaseSheetViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    let containerView = UIView()
    private let topBarView = UIView()
    let contentAreaView = UIView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
}

// MARK: - Private Extensions

private extension BaseSheetViewController {
    func setupStyle() {
        view.backgroundColor = .clear
        
        containerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
        }
        
        topBarView.do {
            $0.backgroundColor = .black20
            $0.layer.cornerRadius = 2
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(containerView)
        containerView.addSubviews(topBarView, contentAreaView)
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(7)
        }
        
        topBarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.convertByHeightRatio(20))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(33)
            $0.height.equalTo(4)
        }
        
        contentAreaView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
//            $0.bottom.equalToSuperview()
        }
    }
    
    func setupDelegate() {
        
    }
}
