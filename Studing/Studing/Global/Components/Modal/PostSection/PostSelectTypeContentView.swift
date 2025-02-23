//
//  PostSelectTypeContentView.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/21/25.
//

import UIKit

import SnapKit
import Then

final class PostSelectTypeContentView: UIView, SheetContentConfigurable {
    
    // MARK: - SheetContentConfigurable Properties
    
    var contentView: UIView { return self }
    
    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let postSectionStackView = UIStackView()
    private let firstSectionView = PostModalSectionView(type: .firstCome)
    private let announceSectionView = PostModalSectionView(type: .announce)
    
    // MARK: - Action Properties
    
    private var firstSectionTapAction: (() -> Void)?
    private var announceSectionTapAction: (() -> Void)?
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent() {
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    func bindingFirstSectionTap(action: (() -> Void)?) {
        self.firstSectionTapAction = action
        setupFirstSectionTapGesture()
    }
    
    func bindingAnnounceSectionTap(action: (() -> Void)?) {
        self.announceSectionTapAction = action
        setupAnnounceSectionTapGesture()
    }
}

// MARK: - Private Extensions

private extension PostSelectTypeContentView {
    func setupStyle() {
        postSectionStackView.do {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.spacing = 8
            $0.addArrangedSubviews(firstSectionView, announceSectionView)
        }
        
        titleLabel.do {
            $0.text = "알맞는 공지사항으로 작성해요!"
            $0.font = .interSubtitle1()
            $0.textColor = .black50
        }
        
        firstSectionView.do {
            $0.layer.cornerRadius = 12
        }
        
        announceSectionView.do {
            $0.layer.cornerRadius = 12
        }
    }
    
    func setupHierarchy() {
        addSubviews(titleLabel, postSectionStackView)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.horizontalEdges.equalToSuperview().inset(26)
        }
        
        postSectionStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(18)
        }
        
        firstSectionView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        announceSectionView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
    
    func setupFirstSectionTapGesture() {
        firstSectionView.do {
            $0.layer.cornerRadius = 12
            $0.addTapAnimation { [weak self] in
                self?.firstSectionTapAction?()
            }
        }
    }
    
    func setupAnnounceSectionTapGesture() {
        announceSectionView.do {
            $0.addTapAnimation { [weak self] in
                self?.announceSectionTapAction?()
            }
        }
    }
}
