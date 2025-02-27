//
//  TimePickerModalContentView.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/22/25.
//

import UIKit

import SnapKit
import Then

class TimePickerModalContentView: UIView, SheetContentConfigurable {

    // MARK: - Properties
    
    private let type: PostPickerType
    private weak var viewModel: PostAnnounceViewModel?
    
    // MARK: - SheetContentConfigurable Properties
    
    var contentView: UIView { return self }
    
    // MARK: - UI Properties
    
    let timePickerView = CustomTimePickerView()
    
    // MARK: - Init
    
    init(type: PostPickerType, viewModel: PostAnnounceViewModel) {
        self.type = type
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent() {
        setupHierarchy()
        setupLayout()
    }
    
    func updateInitialDate() {
        
        let initialTime: DateComponents?
        
        switch type {
        case .start:
            initialTime = viewModel?.startTimeSubject.value

        case .end:
            initialTime = viewModel?.endTimeSubject.value
        }
        
        if let initialTime, let hour = initialTime.hour, let minute = initialTime.minute {
            
            let firstIndex: Int = hour > 12 ? 1 : 0
            let secondIndex: Int = hour > 12 ? hour % 12 : hour
            
            timePickerView.selectRow(firstIndex, inComponent: 0, animated: false)
            timePickerView.selectRow(secondIndex, inComponent: 1, animated: false)
            timePickerView.selectRow(minute, inComponent: 2, animated: false)
        }
    }
}

// MARK: - Private Extensions

private extension TimePickerModalContentView {
    func setupHierarchy() {
        addSubview(timePickerView)
    }
    
    func setupLayout() {
        timePickerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
