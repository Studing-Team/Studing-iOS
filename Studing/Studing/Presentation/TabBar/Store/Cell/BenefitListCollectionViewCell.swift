//
//  BenefitListCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/7/24.
//

import UIKit

import SnapKit
import Then

final class BenefitListCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    
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

extension BenefitListCollectionViewCell {
    func configureCell(title: String) {
        titleLabel.text = "• \(title)"
    }
}

// MARK: - Extensions

private extension BenefitListCollectionViewCell {
    func setupStyle() {
        titleLabel.do {
            $0.textColor = .black50
            $0.font = .interSubtitle4()
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
        }
    }
    
    func setupHierarchy() {
        contentView.addSubview(titleLabel)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
