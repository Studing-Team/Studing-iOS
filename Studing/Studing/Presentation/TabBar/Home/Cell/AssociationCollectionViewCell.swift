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
    private let associationMainView = UIView()
    private let associationLogoImage = AFImageView()
    private let associationNameLabel = UILabel()
    private let unReadView = UIView()

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
        if model.name == "전체" {
            associationLogoImage.image = .allAssociation
        } else {
            associationLogoImage.setImage(model.image, type: .associationLogo, forceReload: true)
        }
        
        associationNameLabel.text = model.name
        unReadView.isHidden = model.unRead ? false : true

        updateSelectionState(model.isSelected)
    }
}

// MARK: - Private Extensions

private extension AssociationCollectionViewCell {
    func setupStyle() {
        associationMainView.do {
            $0.backgroundColor = .white.withAlphaComponent(0.15)
            $0.layer.borderWidth = 1
            $0.layer.borderColor =  UIColor.white.cgColor
            $0.layer.cornerRadius = 15
            $0.clipsToBounds = true
        }
        
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
        
        unReadView.do {
            $0.backgroundColor = .studingRed
            $0.layer.cornerRadius = 6
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(associationMainView, unReadView)
        associationMainView.addSubview(verticalStackView)
    }
    
    func setupLayout() {
        
        associationMainView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(2)
        }
        
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
        
        unReadView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.size.equalTo(12)
        }
    }
    
    func updateSelectionState(_ isSelected: Bool) {
        associationMainView.backgroundColor = isSelected ? .white : .white.withAlphaComponent(0.15)
    }
}
