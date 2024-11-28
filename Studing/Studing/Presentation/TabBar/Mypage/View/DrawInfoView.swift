//
//  DrawInfoView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/26/24.
//

import UIKit

import SnapKit
import Then

enum DrawInfoType {
    case first
    case second
    
    var title: String {
        switch self {
        case .first:
            return "📌 처음부터 다시 가입해야 해요"
            
        case .second:
            return "🥺 스튜딩과 함께한 기록이 사라져요"
        }
    }
    
    var subTitle: String {
        switch self {
        case .first:
            return "탈퇴 회원의 정보는 탈퇴 후 완전히 삭제돼요.\n스튜딩을 떠나시면 회원가입부터 다시 해야해요"
            
        case .second:
            return "저장한 공지 및 좋아요 기록이 전부 사라져요.\n필요한 대학교 정보를 더 받아보시는 게 어떨까요?"
        }
    }
}

final class DrawInfoView: UIView {
    
    private let sectionType: DrawInfoType
    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    // MARK: - init
    
    init(sectionType: DrawInfoType) {
        self.sectionType = sectionType
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension DrawInfoView {
    func setupStyle() {
        backgroundView.do {
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.black10.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 20
        }
        
        titleLabel.do {
            $0.text = sectionType.title
            $0.textColor = .black50
            $0.font = .interSubtitle3()
        }
        
        subTitleLabel.do {
            $0.textColor = .black40
            $0.font = .interBody5()
            $0.numberOfLines = 0
            
            let attributedString = NSMutableAttributedString(string: sectionType.subTitle)

            // 줄 간격 스타일 적용
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5 // 줄 간격 설정
            paragraphStyle.alignment = .left
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            $0.attributedText = attributedString
        }
    }
    
    func setupHierarchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubviews(titleLabel, subTitleLabel)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func setupDelegate() {
        
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("DrawInfoView") {
    DrawInfoView(sectionType: .first)
        .showPreview()
}
#endif
