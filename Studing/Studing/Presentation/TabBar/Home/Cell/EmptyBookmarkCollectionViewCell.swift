//
//  EmptyBookmarkCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/20/24.
//

import UIKit

import SnapKit
import Then

final class EmptyBookmarkCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let allAnnouceButton = UIButton()
    
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

private extension EmptyBookmarkCollectionViewCell {
    func setupStyle() {
        
        self.backgroundColor = .white.withAlphaComponent(0.7)
        self.layer.borderWidth = 1
        self.layer.borderColor =  UIColor.white.cgColor
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        titleLabel.do {
            $0.text = "아직 저장한 공지사항이 없어요"
            $0.font = .interSubtitle2()
            $0.textColor = .black50
        }
        
        subTitleLabel.do {
            $0.text = "필요한 공지사항을 저장하여 빠르게 확인해보세요"
            $0.font = .interCaption12()
            $0.textColor = .black40
        }
        
        allAnnouceButton.do {
            var config = UIButton.Configuration.filled()
            let titleString = AttributedString("전체 공지사항 보기", attributes: .init(
                [.font: UIFont.interBody2()]
            ))
            config.attributedTitle = titleString
            config.baseBackgroundColor = .primary50
            config.baseForegroundColor = .white

            $0.configuration = config
            $0.layer.cornerRadius = 22 / 2
            $0.clipsToBounds = true
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(titleLabel, subTitleLabel, allAnnouceButton)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22.5)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        allAnnouceButton.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(212)
            $0.height.equalTo(22)
        }
    }
}
