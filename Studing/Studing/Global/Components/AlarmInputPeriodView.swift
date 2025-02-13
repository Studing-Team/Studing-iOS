//
//  AlarmInputPeriodView.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/5/25.
//

import UIKit

import SnapKit
import Then

enum AlarmPeriodType {
    case calendar
    case time
}

final class AlarmInputPeriodView: UIView {
    
    // MARK: - Properties
    
    private var alarmPeriodType: AlarmPeriodType
    private var bottomButtonAction: (() -> Void)?
    
    // MARK: - UI Properties
    
    private let backgroundView = UIView()
    private let topBarView = UIView()
    private let contentView = UIView()
    
    lazy var dateView = UICalendarView()
    lazy var timePickerView = CustomTimePickerView()
    
    private let bottomButton: CustomButton
    
    // MARK: - Life Cycle
    
    init(alarmPeriodType: AlarmPeriodType) {
        self.alarmPeriodType = alarmPeriodType
        
        switch alarmPeriodType {
        case .calendar:
            self.bottomButton = CustomButton(buttonStyle: .alarmDay)
        case .time:
            self.bottomButton = CustomButton(buttonStyle: .alarmTime)
        }
        
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindingTimePicker(_ firstIndex: Int, _ secondIndex: Int, _ minute: Int) {
        timePickerView.selectRow(firstIndex, inComponent: 0, animated: false)
        timePickerView.selectRow(secondIndex, inComponent: 1, animated: false)
        timePickerView.selectRow(minute, inComponent: 2, animated: false)
    }
    
    func bindingDay(_ initialDate: DateComponents) {
        if let selection = dateView.selectionBehavior as? UICalendarSelectionSingleDate {
            selection.setSelected(initialDate, animated: true)
        }
    }
    
    func bindingBottomButtonAction(action: (() -> Void)?) {
        self.bottomButton.buttonAction = action
    }
}

// MARK: - Private Extensions

private extension AlarmInputPeriodView {
    func setupStyle() {
        backgroundView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
        }
        
        topBarView.do {
            $0.backgroundColor = .black20
            $0.layer.cornerRadius = 2
        }
        
        dateView.do {
            $0.wantsDateDecorations = false
            $0.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        }
    }
    
    func setupHierarchy() {
        addSubviews(backgroundView)
        backgroundView.addSubviews(topBarView, contentView, bottomButton)
        contentView.addSubview(alarmPeriodType == .calendar ? dateView : timePickerView)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(7)
            $0.horizontalEdges.equalToSuperview()
//            $0.height.equalTo(convertByHeightRatio(alarmPeriodType == .calendar ? 411 : 300))
        }

        topBarView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(20))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(33)
            $0.height.equalTo(4)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        bottomButton.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(14)
            $0.height.equalTo(49)
        }
        
        switch alarmPeriodType {
        case .calendar:
            dateView.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
                $0.verticalEdges.equalToSuperview()
            }
        case .time:
            timePickerView.snp.makeConstraints {
                $0.edges.equalToSuperview()
//                $0.horizontalEdges.equalToSuperview()
//                $0.bottom.equalToSuperview()
            }
        }
    }
    
    func setupDelegate() {
        switch alarmPeriodType {
        case .calendar:
            dateView.delegate = self
        case .time:
            break
        }
    }
}


extension AlarmInputPeriodView: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
    }
}

extension AlarmInputPeriodView: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return nil
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("AlarmInputPeriodView") {
    AlarmInputPeriodView(alarmPeriodType: .time)
        .showPreview()
}
#endif
