//
//  CustomHeaderCollectionReusableView.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/18/24.
//

import UIKit

import SnapKit
import Then

final class CustomHeaderCollectionReusableView: UICollectionReusableView {
    
    var rightButtonTapped: (() -> Void)?
    
    // MARK: - UI Components

    private var type: SectionType?
    private let headerTitleLabel = UILabel()
    private let rightButton = UIButton()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        createRightButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension CustomHeaderCollectionReusableView {
    func configureHeader(type: SectionType, headerTitle: String) {
        self.type = type
        switch type {
        case .missAnnouce:
            headerTitleLabel.text = ""
            rightButton.isHidden = true
        case .association:
            headerTitleLabel.text = "\(headerTitle)의 학생회 소식"
            rightButton.isHidden = true
        case .annouce:
            headerTitleLabel.text = "\(headerTitle) 공지사항이에요"
            rightButton.isHidden = false
        case .bookmark:
            headerTitleLabel.text = "\(headerTitle)님이 저장한 공지사항이에요"
            rightButton.isHidden = false
        case .emptyBookmark:
            headerTitleLabel.text = "필요한 공지만 골라서 저장해요 :)"
            rightButton.isHidden = true
        }
        
        self.layoutIfNeeded()
    }
}

// MARK: - Private Extensions

private extension CustomHeaderCollectionReusableView {
    func setupStyle() {
        headerTitleLabel.do {
            $0.font = .interSubtitle2()
            $0.textColor = .black50
        }
        
        rightButton.do {
            $0.isHidden = true
            $0.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(headerTitleLabel, rightButton)
    }
    
    func setupLayout() {
        headerTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func createRightButton() {
        var config = UIButton.Configuration.plain()
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular)
        config.image = UIImage(systemName: "chevron.right", withConfiguration: symbolConfig)

        // 타이틀과 이미지의 색상 설정
        config.baseForegroundColor = .black30

        // 이미지 위치 설정 (오른쪽)
        config.imagePlacement = .trailing
        config.imagePadding = 8 // 텍스트와 이미지 간격

        // 타이틀의 폰트 설정
        config.attributedTitle = AttributedString("더보기", attributes: AttributeContainer([.font: UIFont.interBody2()]))

        rightButton.configuration = config
    }
    
    @objc private func didTapRightButton() {
       rightButtonTapped?()
    }
}
