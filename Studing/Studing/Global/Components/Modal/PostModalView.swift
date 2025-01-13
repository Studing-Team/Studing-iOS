//
//  PostModalView.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/10/25.
//

import UIKit

import SnapKit
import Then

final class PostModalView: UIView {

    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let contentStackView = UIStackView()
    private let postFirstSectionView = PostModalSectionView(type: .firstServed)
    private let postSectionView = PostModalSectionView(type: .announce)
    
    // MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension PostModalView {
    func setupStyle() {
        
        self.backgroundColor = .white
        
        contentStackView.do {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.spacing = 8
            $0.addArrangedSubviews(postFirstSectionView, postSectionView)
        }
        
        titleLabel.do {
            $0.text = "알맞는 공지사항으로 작성해요!"
            $0.font = .interSubtitle1()
            $0.textColor = .black50
        }
        
        postSectionView.do {
            $0.layer.cornerRadius = 12
        }
        
        postFirstSectionView.do {
            $0.layer.cornerRadius = 12
        }
    }
    
    func setupHierarchy() {
        addSubviews(titleLabel, contentStackView)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(convertByHeightRatio(36))
            $0.horizontalEdges.equalToSuperview()
        }
        
        postSectionView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        postFirstSectionView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("PostModalView") {
    PostModalView()
        .showPreview()
}
#endif
