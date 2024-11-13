//
//  AssociationCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/18/24.
//

import UIKit

import SnapKit
import Then

final class AssociationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let verticalStackView = UIStackView()
    private let associationLogoImage = AFImageView()
    private let associationNameLabel = UILabel()

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

extension AssociationCollectionViewCell {
    func configureCell(forModel model: AssociationEntity) {
        associationLogoImage.setImage(model.image, type: .associationLogo)
        associationNameLabel.text = model.name
        updateSelectionState(model.isSelected)
    }
}

// MARK: - Private Extensions

private extension AssociationCollectionViewCell {
    func setupStyle() {
        
        self.backgroundColor = .white.withAlphaComponent(0.15)
        self.layer.borderWidth = 1
        self.layer.borderColor =  UIColor.white.cgColor
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        verticalStackView.do {
            $0.axis = .vertical
            $0.spacing = 7
            $0.alignment = .center
            $0.addArrangedSubviews(associationLogoImage, associationNameLabel)
        }
        
        associationLogoImage.do {
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 55 / 2
            $0.clipsToBounds = true
        }
        
        associationNameLabel.do {
            $0.font = .interCaption10()
            $0.textColor = .black50
            $0.textAlignment = .center
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(verticalStackView)
    }
    
    func setupLayout() {
        verticalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 12.5, left: 10, bottom: 12.5, right: 10))
        }
        
        associationLogoImage.snp.makeConstraints {
            $0.width.height.equalTo(55)
        }
        
        // 레이블의 너비를 스택 뷰의 너비와 동일하게 설정
        associationNameLabel.snp.makeConstraints {
            $0.width.equalTo(verticalStackView)
        }
    }
    
    func updateSelectionState(_ isSelected: Bool) {
        backgroundColor = isSelected ? .white : .white.withAlphaComponent(0.15)
    }
}
