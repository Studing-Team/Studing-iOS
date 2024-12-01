//
//  EmptyStateView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/7/24.
//

import UIKit

import SnapKit
import Then

final class EmptyStateView: UIView {
    
    // MARK: - UI Properties
    
    private let containerView = UIView()
    private let emptyImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
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

private extension EmptyStateView {
    func setupStyle() {
        containerView.do {
            $0.backgroundColor = .white.withAlphaComponent(0.5)
            $0.layer.cornerRadius = 15
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
        }
        
        emptyImageView.do {
            $0.image = UIImage(resource: .nodata)
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.text = "찾으시는 제휴 업체가 없어요"
            $0.font = .interSubtitle2()
            $0.textColor = .black50
            $0.textAlignment = .center
        }
        
        descriptionLabel.do {
            $0.text = "정확한 제휴 업체명을 검색해주세요!"
            $0.font = .interCaption12()
            $0.textColor = .black30
            $0.textAlignment = .center
        }
    }
    
    func setupHierarchy() {
        addSubviews(containerView)
        containerView.addSubviews(emptyImageView, titleLabel, descriptionLabel)
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(convertByHeightRatio(201))
        }
        
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(convertByHeightRatio(40))
            $0.centerX.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(convertByHeightRatio(25))
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(convertByHeightRatio(8))
            $0.centerX.equalToSuperview()
        }
    }
}
