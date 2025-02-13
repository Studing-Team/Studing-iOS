//
//  PeriodContentView.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/8/25.
//

import UIKit

import SnapKit
import Then

enum PeriodType: String {
    case startDay
    case endDay
    case startTime
    case endTime
}

protocol ContentViewDelegate: AnyObject {
    func contentView(_ contentView: UIView, didTapAction value: Any)
}

final class PeriodContentView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ContentViewDelegate?
    
    private let dateFormatter = DateFormatter()
    private let timeFormatter = DateFormatter()
    
    // MARK: - UI Properties
    
    private let startTitleLabel = UILabel()
    private let startPeriodDayView = PeriodSettingView(type: .days)
    private let startPeriodTimeView = PeriodSettingView(type: .times)
    
    private let endTitleLabel = UILabel()
    private let endPeriodDayView = PeriodSettingView(type: .days)
    private let endPeriodTimeView = PeriodSettingView(type: .times)
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
//        setupTodayAndTimeLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 각 PeriodSettingView 값을 설정하는 메서드들
    func setPeriod(type: PeriodType, text: String) {
        switch type {
        case .startDay:
            startPeriodDayView.bindingTitle(title: text)
        case .endDay:
            endPeriodDayView.bindingTitle(title: text)
        case .startTime:
            startPeriodTimeView.bindingTitle(title: text)
        case .endTime:
            endPeriodTimeView.bindingTitle(title: text)
        }
    }
}

// MARK: - Private Extensions

private extension PeriodContentView {
    func setupStyle() {
        startTitleLabel.do {
            $0.textColor = .black40
            $0.text = "시작 시간"
            $0.font = .interBody1()
        }
        
        endTitleLabel.do {
            $0.textColor = .black40
            $0.text = "종료 시간"
            $0.font = .interBody1()
        }
        
        dateFormatter.do {
            $0.dateFormat = "yyyy년 M월 d일"
            $0.locale = Locale(identifier: "ko_KR")
        }
        
        timeFormatter.do {
            $0.dateFormat = "HH:mm"
        }
        
        setupGesture(for: startPeriodDayView, periodType: .startDay)
        setupGesture(for: startPeriodTimeView, periodType: .startTime)
        setupGesture(for: endPeriodDayView, periodType: .endDay)
        setupGesture(for: endPeriodTimeView, periodType: .endTime)
    }
    
    func setupGesture(for view: UIView, periodType: PeriodType) {
        // PeriodType을 저장할 수 있도록 View에 Objective-C Association 적용
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapButtonView(_:))))
        view.accessibilityValue = "\(periodType)" // PeriodType을 문자열로 저장
    }
    
    @objc func didTapButtonView(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view, let typeString = view.accessibilityValue,
              let periodType = PeriodType(rawValue: typeString) else {
            return
        }
        
        handleTap(for: periodType)
    }
    
    func handleTap(for periodType: PeriodType) {
        delegate?.contentView(self, didTapAction: periodType)
    }
    
    func setupHierarchy() {
        self.addSubviews(
            startTitleLabel,
            startPeriodDayView,
            startPeriodTimeView,
            endTitleLabel,
            endPeriodDayView,
            endPeriodTimeView
        )
    }
    
    func setupLayout() {
        startTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        startPeriodDayView.snp.makeConstraints {
            $0.centerY.equalTo(startTitleLabel)
            $0.leading.equalTo(startTitleLabel.snp.trailing).offset(42)
        }
        
        startPeriodTimeView.snp.makeConstraints {
            $0.centerY.equalTo(startTitleLabel)
            $0.leading.equalTo(startPeriodDayView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
        }
        
        endTitleLabel.snp.makeConstraints {
            $0.top.equalTo(startTitleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        endPeriodDayView.snp.makeConstraints {
            $0.centerY.equalTo(endTitleLabel)
            $0.leading.equalTo(endTitleLabel.snp.trailing).offset(42)
        }
        
        endPeriodTimeView.snp.makeConstraints {
            $0.centerY.equalTo(endTitleLabel)
            $0.leading.equalTo(endPeriodDayView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
        }
    }
    
    func setupDelegate() {
        
    }
    
    func setupTodayAndTimeLabel() {
        let today = dateFormatter.string(from: Date())
        
        let defaultTime = "09:00"
        
        [startPeriodDayView, endPeriodDayView].forEach {
            $0.bindingTitle(title: today)
        }
        
        [startPeriodTimeView, endPeriodTimeView].forEach {
            $0.bindingTitle(title: defaultTime)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("PeriodSectionView") {
    PeriodContentView()
        .showPreview()
}
#endif
