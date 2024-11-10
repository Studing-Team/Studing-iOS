//
//  CustomSearchBarView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/6/24.
//

import UIKit

import SnapKit
import Then

final class CustomSearchBarView: UIView {

    // MARK: - Properties
    
    
    // MARK: - UI Properties
    
    private let containerView = UIView()
    private let searchImageView = UIImageView()
    private let textField = UITextField()
    
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

extension CustomSearchBarView {
    func setupStyle() {
        
        self.backgroundColor = .clear
        
        containerView.do {
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 24
            $0.backgroundColor = .white
        }
        
        searchImageView.do {
            $0.image = UIImage(systemName: "magnifyingglass")
            $0.tintColor = .black30
            $0.contentMode = .scaleAspectFit
        }
        
        textField.do {
            $0.placeholder = "우리대학 제휴업체를 찾아보세요 :)"
            $0.font = .interBody2()
            $0.textColor = .black40
            $0.backgroundColor = .clear
            $0.borderStyle = .none
        }
    }
    
    func setupHierarchy() {
        addSubview(containerView)
        containerView.addSubviews(textField, searchImageView)
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.greaterThanOrEqualTo(48)
        }
        
        searchImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.verticalEdges.equalToSuperview().inset(15)
        }
    }
    
    func setupDelegate() {

    }
}
