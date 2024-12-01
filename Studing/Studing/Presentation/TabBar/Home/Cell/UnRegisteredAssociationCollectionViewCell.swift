//
//  UnRegisteredAssociationCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/26/24.
//

import UIKit

import SnapKit
import Then

final class UnRegisteredAssociationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    private var type: EmptyAnnounceType?
    private let infoImage = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let submittButton = UIButton()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ type: EmptyAnnounceType) {
        self.type = type
        setupLayout()
        self.layer.borderColor =  type == .home ? UIColor.primary50.cgColor : UIColor.white.cgColor
        submittButton.layer.cornerRadius = type == .home ? 24 / 2 : 36 / 2
    }
}

// MARK: - Private Extensions

private extension UnRegisteredAssociationCollectionViewCell {
    func setupStyle() {
        self.backgroundColor = .primary10
        self.layer.borderWidth = 1
        self.layer.borderColor =  type == .home ? UIColor.primary50.cgColor : UIColor.white.cgColor
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        infoImage.do {
            $0.image = UIImage(resource: .nodata)
        }
        
        titleLabel.do {
            $0.text = "등록된 학생회 정보가 없어요"
            $0.font = .interSubtitle2()
            $0.textColor = .black50
        }
        
        subTitleLabel.do {
            $0.text = "아래 구글폼을 통해 학생회 정보를 입력해주세요.\n3일 이내로 빠르게 추가해드릴게요!"
            $0.font = .interCaption12()
            $0.textColor = .black40
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        submittButton.do {
            var config = UIButton.Configuration.filled()
            let titleString = AttributedString("학생회 등록하기", attributes: .init(
                [.font: UIFont.interBody2()]
            ))
            config.attributedTitle = titleString
            config.baseBackgroundColor = .primary50
            config.baseForegroundColor = .white

            $0.configuration = config
            $0.layer.cornerRadius = type == .home ? 24 / 2 : 36 / 2
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(infoImage, titleLabel, subTitleLabel, submittButton)
    }
    
    func setupLayout() {
        infoImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(type == .home ? 20.5 : 142.5)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(infoImage.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        submittButton.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(212)
            $0.height.equalTo(type == .home ? 24 : 36)
            $0.bottom.equalToSuperview().inset(type == .home ? 20.5 : 141.5)
        }
    }
    
    @objc func buttonTapped() {
        guard let url = URL(string: StringLiterals.Web.addMajor),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
