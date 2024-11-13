//
//  BookmarkCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/18/24.
//

import UIKit

import SnapKit
import Then

final class BookmarkCollectionViewCell: UICollectionViewCell {
    
    private let associationTypeView = AssociationTypeView()
    private let titleLabel = UILabel()
    private let contentsLabel = UILabel()
    private let postDayLabel = UILabel()
    private let bookmarkImage = UIImageView()
    
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

extension BookmarkCollectionViewCell {
    func configureCell(forModel model: BookmarkAnnounceEntity) {
        associationTypeView.configure(title: model.association, type: model.associationType)
        titleLabel.text = "\(model.title)"
        contentsLabel.text = "\(model.contents)"
        postDayLabel.text = "\(model.days)"
    }
}

// MARK: - Private Extensions

private extension BookmarkCollectionViewCell {
    func setupStyle() {
        
        self.backgroundColor = .white.withAlphaComponent(0.7)
        self.layer.borderWidth = 1
        self.layer.borderColor =  UIColor.white.cgColor
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
            
        titleLabel.do {
            $0.font = .interSubtitle3()
            $0.textColor = .black50
        }
        
        contentsLabel.do {
            $0.font = .interCaption12()
            $0.textColor = .black50
            $0.numberOfLines = 1
        }
        
        postDayLabel.do {
            $0.font = .interCaption11()
            $0.textColor = .black30
        }
        
        bookmarkImage.do {
            $0.image = UIImage(resource: .selectedBookmark)
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(associationTypeView, titleLabel, contentsLabel, postDayLabel, bookmarkImage)
    }
    
    func setupLayout() {
        associationTypeView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17.25)
            $0.leading.equalToSuperview().inset(15)
//            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(associationTypeView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
        postDayLabel.snp.makeConstraints {
            $0.top.equalTo(contentsLabel.snp.bottom).offset(16.75)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalTo(bookmarkImage.snp.leading).inset(10)
            $0.bottom.equalToSuperview().inset(22)
        }
        
        bookmarkImage.snp.makeConstraints {
            $0.top.equalTo(contentsLabel.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(17.5)
            $0.width.equalTo(21)
            $0.height.equalTo(22.5)
        }
    }
}
