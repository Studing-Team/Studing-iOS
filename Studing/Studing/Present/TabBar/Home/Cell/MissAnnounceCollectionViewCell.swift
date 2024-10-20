//
//  MissAnnounceCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/18/24.
//

import UIKit

import SnapKit
import Then

final class MissAnnounceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let verticalStackView = UIStackView()
    private let horizontalTitleStackView = UIStackView()
    private let userNameTitleLabel = UILabel()
    private let missAnnounceCount = UILabel()
    private let subTitleLabel = UILabel()
    
    // MARK: - Life Cycles
    
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

extension MissAnnounceCollectionViewCell {
    func configureCell(forModel model : MissAnnounceModel) {
        userNameTitleLabel.text = "\(model.userName)님이 놓친 공지사항"
        missAnnounceCount.text = "\(model.missAnnounceCount)개"
    }
}

// MARK: - Private Extensions

private extension MissAnnounceCollectionViewCell {
    func setupStyle() {
        self.applyGradient(colors: [.announceStartGradient, .announceEndGradient], direction: .topToBottom, locations: [0, 1])
        
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        verticalStackView.do {
            $0.axis = .vertical
            $0.addArrangedSubviews(horizontalTitleStackView, subTitleLabel)
            $0.spacing = 5
        }
            
        horizontalTitleStackView.do {
            $0.axis = .horizontal
            $0.addArrangedSubviews(userNameTitleLabel, missAnnounceCount)
            $0.spacing = 2
        }
        
        userNameTitleLabel.do {
            $0.font = .interSubtitle1()
            $0.textColor = .white
        }
        
        missAnnounceCount.do {
            $0.font = .interSubtitle1()
            $0.textColor = .primary50
        }
        
        subTitleLabel.do {
            $0.text = "나만 모르는 이벤트, 놓치지 말아요!"
            $0.font = .interCaption12()
            $0.textColor = .white
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(verticalStackView)
    }
    
    func setupLayout() {
        verticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(45)
            $0.leading.equalToSuperview().offset(convertByWidthRatio(16))
            $0.bottom.equalToSuperview().inset(18)
        }
    }
}
