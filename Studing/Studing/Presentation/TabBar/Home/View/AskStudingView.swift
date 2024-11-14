//
//  AskStudingView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/14/24.
//

import UIKit

import SnapKit
import Then

final class AskStudingView: UIView {
    private let backgroundView = UIView()
    private let askImageView = UIImageView()
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension AskStudingView {
    func setupStyle() {
        backgroundView.do {
            $0.backgroundColor = .black10
            $0.layer.cornerRadius = 24
        }
        
        askImageView.do {
            $0.image = UIImage(resource: .inquiry)
        }
        
        arrowImageView.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .black50
        }
        
        titleLabel.do {
            $0.textColor = .black50
            $0.text = "스튜딩 문의하기"
            $0.font = .interBody2()
        }
    }
    
    func setupHierarchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubviews(askImageView, titleLabel, arrowImageView)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        askImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            $0.size.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(askImageView.snp.trailing).offset(8)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
        }
    }
    
    func setupDelegate() {
        
    }
}

