//
//  EmptyBookmarkListCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/14/24.
//

import UIKit

import SnapKit
import Then

final class EmptyBookmarkListCollectionViewCell: UICollectionViewCell {
    
    private let emptyImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitle = UILabel()
    
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

// MARK: - Private Extensions

private extension EmptyBookmarkListCollectionViewCell {
    func setupStyle() {
        
        self.backgroundColor = .white.withAlphaComponent(0.5)
        self.layer.borderWidth = 1
        self.layer.borderColor =  UIColor.white.cgColor
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        emptyImageView.do {
            $0.image = UIImage(resource: .emptyDataBlue)
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.font = .interSubtitle2()
            $0.text = "저장한 공지사항이 없어요"
            $0.textColor = .black50
        }
        
        subTitle.do {
            $0.font = .interCaption12()
            $0.text = "필요한 공지사항을 저장하여 빠르게 확인해보세요."
            $0.textColor = .black30
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(emptyImageView, titleLabel, subTitle)
    }
    
    func setupLayout() {
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(167.86)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(60.28)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        subTitle.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
//            $0.bottom.equalToSuperview().inset(167.86))
        }
    }
}
