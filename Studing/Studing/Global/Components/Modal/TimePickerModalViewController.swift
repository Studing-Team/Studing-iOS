//
//  TimePickerModalViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/12/25.
//

import UIKit

import SnapKit
import Then

enum PostPickerType {
    case start
    case end
}

final class TimePickerModalViewController: SingleButtonSheetViewController {
    
    // MARK: - Properties
    
    private var type: PostPickerType
    private var buttonSttyle: ButtonStyle
    
    // MARK: - UI Properties
    
    private let timePickerView = CustomTimePickerView()
        
    // MARK: - Init
        
    init(type: PostPickerType) {
        self.type = type
        
        switch type {
        case .start:
            buttonSttyle = .startTime
        case .end:
            buttonSttyle = .endTime
        }
        
        super.init(
            buttonStyle: buttonSttyle
        )
        
        self.bindingBottomButtonAction(action: { [weak self] in
            self?.dismiss(animated: true)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
}

// MARK: - Private Extensions

private extension TimePickerModalViewController {
    func setupStyle() {
        
    }
    
    func setupHierarchy() {
        self.contentAreaView.addSubviews(timePickerView)
    }
    
    func setupLayout() {
        timePickerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setupDelegate() {
        
    }
}


final class CustomTimePickerView: UIPickerView {
    
    // MARK: - Properties
    
    private let ampmSection = ["오전", "오후"]
    private let hoursSection = Array(1...12)
    private let minutesSection = Array(0...59)
    
    // MARK: - UI Properties
    
//    private let pickerView = UIPickerView()
    
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
}

// MARK: - Private Extensions

private extension CustomTimePickerView {
    func setupStyle() {

    }
    
    func setupHierarchy() {
//        self.addSubviews(pickerView)
    }
    
    func setupLayout() {
        
    }
    
    func setupDelegate() {
        self.dataSource = self
        self.delegate = self
    }
}

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
