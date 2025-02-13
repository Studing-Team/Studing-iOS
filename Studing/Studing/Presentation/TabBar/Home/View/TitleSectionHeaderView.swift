//
//  TitleSectionHeaderView.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/8/25.
//

import UIKit

import SnapKit
import Then

final class TitleSectionHeaderView: UIView {
    
    // MARK: - Properties
    
    private let type: TitleType
    
    private var postType: PostDisplayType {
        if isAnnounceType {
            return .announce
        } else {
            return .firstCome
        }
    }
    
    var onCheckBoxStateChanged: ((CheckBoxState) -> Void)?
    
    private var isAnnounceType: Bool {
        if case .period(let periodType) = type, case .announce = periodType {
            return true
        }
        return false
    }

    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private lazy var periodTitleLabel = UILabel()
    private lazy var checkBoxButton = CheckBoxButton()
    private lazy var rightSubTitleLabel = UILabel()
    
    // MARK: - init
    
    init(type: TitleType) {
        self.type = type
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension TitleSectionHeaderView {
    func setupStyle() {
        titleLabel.do {
            $0.textColor = .black40
            $0.text = type.title
            $0.font = .interSubtitle2()
        }
        
        periodTitleLabel.do {
            $0.textColor = .black30
            $0.text = "기간 입력"
            $0.font = .interBody2()
        }
        
        rightSubTitleLabel.do {
            $0.textColor = .black30
            $0.text = "*최대 999명까지 입력 가능합니다."
            $0.font = .interCaption12()
        }
    }
    
    func setupHierarchy() {
        addSubview(titleLabel)

        if isAnnounceType {
            addSubviews(checkBoxButton, periodTitleLabel)
        } else if postType == .firstCome && type == .personNumber {
            addSubview(rightSubTitleLabel)
        }
    }
    
    func setupLayout() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        // 공통 레이아웃
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        // announce 타입일 때만 추가 레이아웃
        if isAnnounceType {
            setupPeriodLayout()
        } else if postType == .firstCome && type == .personNumber {
            setupPersonLayout()
        }
    }
    
    func setupPeriodLayout() {
        checkBoxButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.size.equalTo(20)
        }
        
        periodTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(checkBoxButton.snp.trailing).offset(7)
            $0.trailing.equalToSuperview()
        }
    }
    
    func setupPersonLayout() {
        rightSubTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
        }
    }
    
    func setupButtonAction() {
        checkBoxButton.onTap = { [weak self] state in
            self?.onCheckBoxStateChanged?(state)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("TitleSectionHeaderView") {
    TitleSectionHeaderView(type: .period(type: .announce))
        .showPreview()
}
#endif

