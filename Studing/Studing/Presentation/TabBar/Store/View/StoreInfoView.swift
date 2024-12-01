//
//  StoreInfoView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/28/24.
//

import UIKit

import SnapKit
import Then

final class StoreInfoView: UIView {
    
    // MARK: - UI Properties
    
    private let backgroundView = UIView()
    private let contentStackView = UIStackView()
    private let titleStackView = UIStackView()
    private let categoryStackView = UIStackView()
    
    private let storeImageView = AFImageView()
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let categoryImageView = UIImageView()
    private let descriptionLabel = UILabel()
    
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
    
    func configure(forModel model: StoreEntity) {
        titleLabel.text = model.name
        categoryLabel.text = model.category.title
        categoryImageView.image = model.category.icon
        descriptionLabel.text = model.description
        storeImageView.setImage(model.imageURL, type: .postImage)
    }
}

// MARK: - Private Extensions

private extension StoreInfoView {
    func setupStyle() {
        backgroundView.do {
            $0.backgroundColor = .white.withFigmaStyleAlpha(0.8) //withAlphaComponent(0.8)
            $0.layer.cornerRadius = 15
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black10.cgColor
        }
        
        contentStackView.do {
            $0.addArrangedSubviews(titleStackView, descriptionLabel)
            $0.axis = .vertical
            $0.spacing = 15
            $0.alignment = .fill
            $0.distribution = .equalCentering
        }
        
        titleStackView.do {
            $0.addArrangedSubviews(titleLabel, categoryStackView)
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fill
            $0.alignment = .leading
        }
        
        categoryStackView.do {
            $0.addArrangedSubviews(categoryImageView, categoryLabel)
            $0.axis = .horizontal
            $0.spacing = 2
            $0.distribution = .fillProportionally
            $0.alignment = .center
        }

        titleLabel.do {
            $0.font = .interSubtitle3()
            $0.numberOfLines = 1
            $0.textColor = .black50
            $0.lineBreakMode = .byTruncatingTail
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        categoryLabel.do {
            $0.font = .interCaption11()
            $0.textColor = .black30
        }
        
        storeImageView.do {
            $0.image = UIImage(resource: .dumpstore)
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
        }
        
        descriptionLabel.do {
            $0.font = .interBody5()
            $0.textColor = .black50
            $0.numberOfLines = 2
        }
        
        categoryImageView.do {
            $0.contentMode = .scaleAspectFill
        }
    }
    
    func setupHierarchy() {
        addSubviews(backgroundView)
        backgroundView.addSubviews(contentStackView, storeImageView)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(124)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(storeImageView.snp.leading).offset(-10)
            $0.height.equalTo(convertByHeightRatio(124))
            $0.bottom.equalToSuperview().inset(16)
        }
        
        storeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(92)
        }
        
        categoryStackView.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(34)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.size.equalTo(12)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(0)
        }
    }
}

