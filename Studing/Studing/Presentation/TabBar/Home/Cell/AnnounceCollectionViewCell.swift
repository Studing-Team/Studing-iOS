//
//  AnnouceCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/18/24.
//

import UIKit

import SnapKit
import Then

final class AnnounceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    private let contentsImage = AFImageView()
    private let associationTypeView = AssociationTypeView()
    
    private let titleLabel = UILabel()
    private let contentsLabel = UILabel()
    
    private let postDayLabel = UILabel()
    private let contentInfoView = ContentInfoView()

    private let contentsStackView = UIStackView()
    private let postStackView = UIStackView()
    private let bottomStackView = UIStackView()
    
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

extension AnnounceCollectionViewCell {
    func configureCell(forModel model: AssociationAnnounceEntity) {
        contentsImage.setImage(model.imageURL, type: .postImage, forceReload: true)
        associationTypeView.configure(title: model.writerInfo, type: model.associationType)
        
        titleLabel.text = "\(model.title)"
        contentsLabel.text = "\(model.contents)"
        postDayLabel.text = "\(model.days)"
        
        contentInfoView.configureData(model.favoriteCount, model.bookmarkCount, model.watchCount, model.isFavorite, model.isBookmark)
    }
}

// MARK: - Private Extensions

private extension AnnounceCollectionViewCell {
    func setupStyle() {
        
        self.backgroundColor = .white.withAlphaComponent(0.7)
        self.layer.borderWidth = 1
        self.layer.borderColor =  UIColor.white.cgColor
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        contentsImage.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.font = .interSubtitle3()
            $0.textColor = .black50
            $0.numberOfLines = 1
        }
        
        contentsLabel.do {
            $0.font = .interBody2()
            $0.textColor = .black50
            $0.numberOfLines = 2
        }
        
        postDayLabel.do {
            $0.font = .interCaption11()
            $0.textColor = .black30
        }
        
        bottomStackView.do {
            $0.addArrangedSubviews(postDayLabel, UIView(), contentInfoView)
            $0.axis = .horizontal
            $0.spacing = 0
            $0.distribution = .fill
            $0.alignment = .center
        }
        
        contentsStackView.do {
            $0.addArrangedSubviews(contentsImage, postStackView, bottomStackView)
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .fill
        }
        
        postStackView.do {
            $0.addArrangedSubviews(titleLabel, contentsLabel)
            $0.axis = .vertical
            $0.spacing = 10
            $0.alignment = .top
            $0.distribution = .fill
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(contentsStackView)
        contentsImage.addSubview(associationTypeView)
    }
    
    func setupLayout() {
        contentsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
        }
        
        contentsImage.snp.makeConstraints {
            $0.height.equalTo(199)
        }
        
        contentsStackView.snp.makeConstraints {
            $0.height.equalTo(307)
        }
        
        associationTypeView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        contentsLabel.snp.makeConstraints {
            $0.height.equalTo(34)
        }
        
//        divider.snp.makeConstraints {
//            $0.width.equalTo(1)
//            $0.height.equalTo(12)
//        }
//        
//        divider2.snp.makeConstraints {
//            $0.width.equalTo(1)
//            $0.height.equalTo(12)
//        }
    }
}
