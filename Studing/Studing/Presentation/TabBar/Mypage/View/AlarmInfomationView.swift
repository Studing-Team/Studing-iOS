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
    
    // MARK: - Properties
    
    private var alarmButtonAction: (() -> Void)?
    private var alarmState: AlarmSettingState?
    
    // MARK: - UI Properties
    
    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let alarmSettingButton = UIButton()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeAlarmState(isAlarm: Bool) {
        alarmState = isAlarm ? .alarmOn : .alamrOff
        
        updateLayout()
    }
    
    func updateLayout() {
        guard let alarmState else { return }
        
        setupStyle(state: alarmState)
        setupHierarchy()
        setupLayout()
    }
    
    func setAlarmSettingAction(_ action: @escaping () -> Void) {
        self.alarmButtonAction = action
        
        // 기존에 설정된 Target을 제거한 후, 새로운 Target 추가 (중복 방지)
        alarmSettingButton.removeTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        alarmSettingButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        alarmButtonAction?()
    }
}

// MARK: - Private Extensions

private extension AlarmInfomationView {
    func setupStyle(state: AlarmSettingState) {
        backgroundView.do {
            $0.backgroundColor = .primary10
            $0.layer.cornerRadius = 20
            $0.layer.borderWidth = 0.7
            $0.layer.borderColor = UIColor.primary20.cgColor
        }
        
        titleLabel.do {
            $0.text = state.mainTitle
            $0.textColor = .primary50
            $0.font = .interSubtitle3()
        }
        
        subTitleLabel.do {
            $0.text = state.subTitle
            $0.textColor = .primary40
            $0.font = .interCaption12()
            $0.numberOfLines = 0
        }
        
        alarmSettingButton.do {
            $0.backgroundColor = state.backgroundColor
            $0.layer.cornerRadius = 16
            
            let attributedString = NSAttributedString(string: state.title, attributes: [
                .font: UIFont.interSemiBoldCaption12(),
                .foregroundColor: state.fontColor
            ])
            
            alarmSettingButton.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    func setupHierarchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubviews(titleLabel, subTitleLabel, alarmSettingButton)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(21.5)
            $0.leading.equalToSuperview().offset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(alarmSettingButton.snp.leading)
            $0.bottom.equalToSuperview().inset(21.5)
        }
        
        alarmSettingButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(26)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(69)
            $0.height.equalTo(32)
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
