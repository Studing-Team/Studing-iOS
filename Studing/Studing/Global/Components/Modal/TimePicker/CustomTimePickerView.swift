//
//  CustomTimePickerView.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/21/25.
//

import UIKit

import SnapKit
import Then

final class CustomTimePickerView: UIPickerView {
    
    // MARK: - Properties
    
    private let ampmSection = ["오전", "오후"]
    private let hoursSection = Array(0...12)
    private let minutesSection = Array(0...59)
    
    // MARK: - UI Properties
    
    private let modalTitle = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.subviews.forEach { subview in
            if subview.bounds.height < 1 {
                subview.backgroundColor = .clear
            }
        }
    }
    
    /// 현재 선택된 값을 DateComponents 로 변환하는 메서드
    func selectedTimeComponents() -> DateComponents {
        let isPM = ampmSection[self.selectedRow(inComponent: 0)] == "오후"
        let hour = hoursSection[self.selectedRow(inComponent: 1)]
        let minute = minutesSection[self.selectedRow(inComponent: 2)]

        var components = DateComponents()
        components.hour = isPM ? hour + 12 : hour
        components.minute = minute
        return components
    }
}

// MARK: - Private Extensions

private extension CustomTimePickerView {
    func setupStyle() {
        modalTitle.do {
            $0.text = "시간 선택"
            $0.font = .interSubtitle2()
            $0.textColor = .black50
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(modalTitle)
    }
    
    func setupLayout() {
        modalTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(22)
        }
    }
    
    func setupDelegate() {
        self.dataSource = self
        self.delegate = self
    }
}

// MARK: - UIPickerViewDelegate Extensions

extension CustomTimePickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return ampmSection[row]  // AM/PM
        case 1:
            return "\(hoursSection[row])"  // 시간
        case 2:
            return String(format: "%02d", minutesSection[row])  // 분
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        
        switch component {
        case 0: // AM/PM 컴포넌트
            label.text = ampmSection[row]
        case 1: // 시간 컴포넌트
            label.text = "\(hoursSection[row])"
        case 2: // 분 컴포넌트
            label.text = String(format: "%02d", minutesSection[row])
        default:
            label.text = nil
        }
        
        label.textAlignment = .center
        label.textColor = .primary50
        label.font = .interHeadline3()
        label.backgroundColor = .clear
        
        return label
    }
}

// MARK: - UIPickerViewDataSource Extensions

extension CustomTimePickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3  // AM/PM, 시간, 분
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return ampmSection.count  // AM/PM
        case 1:
            return hoursSection.count  // 시간
        case 2:
            return minutesSection.count  // 분
        default:
            return 0
        }
    }
}
