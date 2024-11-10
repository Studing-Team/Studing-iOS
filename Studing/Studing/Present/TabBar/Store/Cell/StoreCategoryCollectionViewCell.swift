//
//  StoreCategoryCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/6/24.
//

import UIKit

import SnapKit
import Then

enum CategoryType: CaseIterable {
    case all
    case restaurant
    case coffee
    case bar
    case exercise
    case health
    case culture
    
    var title: String {
        switch self {
        case .all:
            return "전체"
        case .restaurant:
            return "음식점"
        case .coffee:
            return "카페"
        case .culture:
            return "문화"
        case .health:
            return "병원"
        case .bar:
            return "술집"
        case .exercise:
            return "운동"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .all:
            return nil
        case .restaurant:
            return UIImage(resource: .restaurant)
        case .coffee:
            return UIImage(resource: .coffee)
        case .culture:
            return UIImage(resource: .culture)
        case .health:
            return UIImage(resource: .health)
        case .bar:
            return UIImage(resource: .bar)
        case .exercise:
            return UIImage(resource: .exercise)
        }
    }
}

final class StoreCategoryCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    private var categoryType: CategoryType?
    private let categoryStack = UIStackView()
    private let cateoryTitleLabel = UILabel()
    private let cateoryImage = UIImageView()
    
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

extension StoreCategoryCollectionViewCell {
    func configureCell(type: CategoryType) {
        self.categoryType = type
        updateCategoryLayout(type)
    }
    
    func updateAppearance() {
        if cateoryTitleLabel.text == "전체" && isSelected == true {
            contentView.applyGradient(colors: [.loginStartGradient.withFigmaStyleAlpha(1.0), .loginEndGradient.withFigmaStyleAlpha(1.0)], direction: .topRightToBottomLeft, locations: [0, 1.0])
            contentView.layer.borderWidth = 0
        } else if cateoryTitleLabel.text == "전체" && isSelected == false  {
            removeGradient()
            contentView.backgroundColor = .white.withAlphaComponent(0.5)
            contentView.layer.borderWidth = 1
        } else {
            contentView.backgroundColor = isSelected ? .white : .white.withAlphaComponent(0.5)
        }
    }
    
    func removeGradient() {
        contentView.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
    }
}

// MARK: - Extensions

private extension StoreCategoryCollectionViewCell {
    func setupStyle() {
        contentView.layer.cornerRadius = 19
        contentView.backgroundColor = .white.withAlphaComponent(0.5)
        contentView.clipsToBounds = true
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1
        
        cateoryTitleLabel.do {
            $0.textAlignment = .center
            $0.font = .interBody2()
        }
        
        categoryStack.do {
            $0.addArrangedSubviews(cateoryImage, cateoryTitleLabel)
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fillProportionally
            $0.alignment = .center
        }
    }
    
    func setupHierarchy() {
        contentView.addSubview(categoryStack)
    }
    
    func setupLayout() {
        categoryStack.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(7)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    func updateCategoryLayout(_ type: CategoryType) {
        cateoryTitleLabel.text = type.title
        
        if type == .all {
            cateoryImage.isHidden = true
        } else {
            cateoryImage.image = type.icon
        }
    }
}
