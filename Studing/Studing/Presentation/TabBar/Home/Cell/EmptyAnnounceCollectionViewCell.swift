//
//  EmptyAnnouceCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import UIKit

import SnapKit
import Then

final class EmptyAnnounceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    private let infoImage = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
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

private extension EmptyAnnounceCollectionViewCell {
    func setupStyle() {
        self.backgroundColor = .white.withAlphaComponent(0.3)
        self.layer.borderWidth = 1
        self.layer.borderColor =  UIColor.white.cgColor
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        infoImage.do {
            $0.image = UIImage(resource: .emptyData)
        }
        
        titleLabel.do {
            $0.text = "등록된 공지사항이 없어요"
            $0.font = .interSubtitle2()
            $0.textColor = .black50
        }
        
        subTitleLabel.do {
            $0.text = "학생회에서 공지를 등록할 때까지 조금만 기다려주세요."
            $0.font = .interCaption12()
            $0.textColor = .black40
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(infoImage, titleLabel, subTitleLabel)
    }
    
    func setupLayout() {
        infoImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(34.86)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(infoImage.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(34.86)
        }
    }
}
