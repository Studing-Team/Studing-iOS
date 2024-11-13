//
//  BookmarkListCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/5/24.
//

import UIKit

import SnapKit
import Then

final class BookmarkListCollectionViewCell: UICollectionViewCell {
    
    private let contentsImage = UIImageView()
    private let titleLabel = UILabel()
    private let postDayLabel = UILabel()
    private let bookmarkImage = UIImageView()
    
    private let contentsStackView = UIStackView()
    private let postStackView = UIStackView()
    
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

extension BookmarkListCollectionViewCell {
    func configureCell(forModel model : BookmarkModel) {
        titleLabel.text = "\(model.title)"
        postDayLabel.text = "\(model.days)"
    }
}

// MARK: - Private Extensions

private extension BookmarkListCollectionViewCell {
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
            $0.numberOfLines = 2
        }
        
        postDayLabel.do {
            $0.font = .interCaption11()
            $0.textColor = .black30
        }
        
        bookmarkImage.do {
            $0.image = UIImage(resource: .selectedBookmark)
        }
        
        contentsStackView.do {
            $0.addArrangedSubviews(contentsImage, postStackView)
            $0.axis = .horizontal
            $0.spacing = 16
            $0.distribution = .fill
            $0.alignment = .center
        }
        
        postStackView.do {
            $0.addArrangedSubviews(titleLabel, postDayLabel)
            $0.axis = .vertical
            $0.spacing = 21
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(contentsStackView, bookmarkImage)
    }
    
    func setupLayout() {
        contentsStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(17)
            $0.trailing.equalTo(bookmarkImage.snp.leading).offset(-19)
        }
        
        contentsImage.snp.makeConstraints {
            $0.size.equalTo(70)
        }
        
        bookmarkImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(17)
            $0.bottom.equalToSuperview().inset(15)
            $0.width.equalTo(20)
            $0.height.equalTo(24)
        }
    }
}
