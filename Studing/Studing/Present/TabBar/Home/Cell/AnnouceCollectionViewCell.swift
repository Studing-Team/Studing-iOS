//
//  AnnouceCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/18/24.
//

import UIKit

import SnapKit
import Then

final class AnnouceCollectionViewCell: UICollectionViewCell {
    
    private let contentsImage = UIImageView()
    private let titleLabel = UILabel()
    private let contentsLabel = UILabel()
    
    private let postDayLabel = UILabel()
    
    private let favoriteCount = UILabel()
    private let bookmarkCount = UILabel()
    private let watchCount = UILabel()
    
    private let favoriteImage = UIImageView()
    private let bookmarkImage = UIImageView()
    private let watchImage = UIImageView()
    
    private let favoriteInfoStackView = UIStackView()
    private let bookmarkInfoStackView = UIStackView()
    private let watchInfoStackView = UIStackView()
    private let contentsInfoStackView = UIStackView()
    
    private let contentsStackView = UIStackView()
    private let postStackView = UIStackView()
    private let bottomStackView = UIStackView()
    
    private let divider = UIView()
    private let divider2 = UIView()
    
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

extension AnnouceCollectionViewCell {
    func configureCell(forModel model: AssociationAnnounceModel) {
        titleLabel.text = "\(model.title)"
        contentsLabel.text = "\(model.contents)"
        
        postDayLabel.text = "\(model.days)"
        
        favoriteCount.text = "\(model.favoriteCount)"
        bookmarkCount.text = "\(model.bookmarkCount)"
        watchCount.text = "\(model.watchCount)"
        
        favoriteImage.image = UIImage(resource: model.isFavorite == true ? .favorite : .favorite)
        bookmarkImage.image = UIImage(resource: model.isBookmark == true ? .bookmark : .bookmark)
        watchImage.image = UIImage(resource: .visibility)
    }
}

// MARK: - Private Extensions

private extension AnnouceCollectionViewCell {
    func setupStyle() {
        
        self.backgroundColor = .white.withAlphaComponent(0.7)
        self.layer.borderWidth = 1
        self.layer.borderColor =  UIColor.white.cgColor
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        contentsImage.do {
            $0.image = UIImage(resource: .dump)
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.font = .interBody2()
            $0.textColor = .black50
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
        
        divider.do {
            $0.backgroundColor = .black30
        }
        
        divider2.do {
            $0.backgroundColor = .black30
        }
        
        [favoriteCount, bookmarkCount, watchCount].forEach {
            $0.font = .interCaption11()
            $0.textColor = .black30
        }
        
        favoriteInfoStackView.do {
            $0.addArrangedSubviews(favoriteImage, favoriteCount)
        }
        
        bookmarkInfoStackView.do {
            $0.addArrangedSubviews(bookmarkImage, bookmarkCount)
        }
        
        watchInfoStackView.do {
            $0.addArrangedSubviews(watchImage, watchCount)
        }
        
        [favoriteInfoStackView, bookmarkInfoStackView, watchInfoStackView].forEach {
            $0.axis = .horizontal
            $0.spacing = 3
            $0.distribution = .fill
        }
        
        contentsInfoStackView.do {
            $0.addArrangedSubviews(favoriteInfoStackView, divider, bookmarkInfoStackView, divider2, watchInfoStackView)
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .equalCentering
        }
        
        bottomStackView.do {
            $0.addArrangedSubviews(postDayLabel, contentsInfoStackView)
            $0.axis = .horizontal
            $0.spacing = 101
            $0.distribution = .fillProportionally
        }
        
        contentsStackView.do {
            $0.addArrangedSubviews(contentsImage, postStackView, bottomStackView)
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .equalSpacing
        }
        
        postStackView.do {
            $0.addArrangedSubviews(titleLabel, contentsLabel)
            $0.axis = .vertical
            $0.spacing = 10
            $0.distribution = .equalSpacing
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(contentsStackView)
    }
    
    func setupLayout() {
        contentsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
        }
        
        contentsImage.snp.makeConstraints {
            $0.height.equalTo(199)
        }
        
        divider.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(12)
        }
        
        divider2.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(12)
        }
    }
}
