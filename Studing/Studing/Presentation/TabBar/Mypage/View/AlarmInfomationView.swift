//
//  AlarmInfomationView.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/22/25.
//

import UIKit

import SnapKit
import Then

final class AlarmInfomationView: UIView {
    
    // MARK: - UI Properties
    
    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let arrowImageView = UIImageView()
    
    // MARK: - Init
    
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

private extension AlarmInfomationView {
    func setupStyle() {
        backgroundView.do {
            $0.backgroundColor = .primary10
            $0.layer.cornerRadius = 20
        }
        
        titleLabel.do {
            $0.text = "알림을 켜주세요"
            $0.textColor = .primary50
            $0.font = .interSubtitle3()
        }
        
        subTitleLabel.do {
            $0.text = "OS 알림이 꺼져 있으면, 알림을 받을 수 없어요.\nOS 설정에서 알림을 켜주세요."
            $0.textColor = .primary40
            $0.font = .interCaption12()
            $0.numberOfLines = 0
        }
        
        arrowImageView.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .primary50
        }
    }
    
    func setupHierarchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubviews(titleLabel, subTitleLabel, arrowImageView)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(arrowImageView.snp.leading)
            $0.bottom.equalToSuperview().inset(14)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(32)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("AlarmInfomationView") {
    AlarmInfomationView()
        .showPreview()
}
#endif
