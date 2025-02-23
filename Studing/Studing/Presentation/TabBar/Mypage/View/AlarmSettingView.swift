//
//  AlarmSettingView.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/22/25.
//

import UIKit

import SnapKit
import Then

final class AlarmSettingView: UIView {
    
    // MARK: - UI Properties
    
    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let announceSwitchView = UISwitch()
    
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
    
    func changeAnnounceSwitchOn(_ isOn: Bool) {
        announceSwitchView.isOn = isOn
        announceSwitchView.isEnabled = isOn
    }
}

// MARK: - Private Extensions

private extension AlarmSettingView {
    func setupStyle() {
        backgroundView.do {
            $0.backgroundColor = .black5
        }
        
        titleLabel.do {
            $0.text = "공지사항 알림"
            $0.textColor = .black50
            $0.font = .interSubtitle2()
        }
        
        subTitleLabel.do {
            $0.text = "새로운 공지, 리마인드 푸쉬 알림"
            $0.textColor = .black30
            $0.font = .interBody3()
            $0.numberOfLines = 0
        }
        
        announceSwitchView.do {
            $0.onTintColor = .primary50
            $0.isEnabled = true
        }
    }
    
    func setupHierarchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubviews(titleLabel, subTitleLabel, announceSwitchView)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(95)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalToSuperview().offset(5)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(5)
        }
        
        announceSwitchView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("AlarmSettingView") {
    AlarmSettingView()
        .showPreview()
}
#endif
