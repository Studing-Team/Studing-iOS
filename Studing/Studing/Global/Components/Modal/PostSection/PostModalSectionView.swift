//
//  PostModalSectionView.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/10/25.
//

import UIKit

import SnapKit
import Then

final class PostModalSectionView: UIView, TappableView {
    
    // MARK: - Properties
    
    private let type: PostDisplayType

    // MARK: - UI Properties
    
    private let leftImageView = UIImageView()
    private let titleLabel = UILabel()
    private let rightImageView = UIImageView()
    
    // MARK: - Init
    
    init(type: PostDisplayType) {
        self.type = type
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

private extension PostModalSectionView {
    func setupStyle() {
        self.backgroundColor = .white
        
        leftImageView.do {
            $0.image = UIImage(resource: type == .announce ? .postList : .postTime)
            $0.contentMode = .scaleAspectFit
        }
        
        rightImageView.do {
            $0.image = UIImage(resource: .rightArrow)
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.text = type.title
            $0.font = .interBody1()
            $0.textColor = .black40
        }
    }
    
    func setupHierarchy() {
        addSubviews(leftImageView, titleLabel, rightImageView)
    }
    
    func setupLayout() {
        leftImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(leftImageView)
            $0.leading.equalTo(leftImageView.snp.trailing).offset(10)
        }
        
        rightImageView.snp.makeConstraints {
            $0.centerY.equalTo(leftImageView)
            $0.trailing.equalToSuperview().inset(8)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("PostModalSectionView") {
    PostModalSectionView(type: .announce)
        .showPreview()
}
#endif
