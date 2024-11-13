//
//  MypageHeaderCollectionReusableView.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import UIKit

import SnapKit
import Then

final class MypageHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - UI Components

    private let headerTitleLabel = UILabel()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension MypageHeaderCollectionReusableView {
    func configureHeader(headerTitle: String) {
        headerTitleLabel.text = headerTitle
    }
}

// MARK: - Private Extensions

private extension MypageHeaderCollectionReusableView {
    func setupStyle() {
        headerTitleLabel.do {
            $0.font = .interSubtitle2()
            $0.textColor = .black50
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(headerTitleLabel)
    }
    
    func setupLayout() {
        headerTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
