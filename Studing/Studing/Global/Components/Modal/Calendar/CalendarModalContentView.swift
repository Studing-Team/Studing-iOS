//
//  CalendarModalContentView.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/21/25.
//

import UIKit

import SnapKit
import Then

class CalendarModalContentView: UIView, SheetContentConfigurable {
    
    // MARK: - Properties
    
    private let type: PostPickerType
    private weak var viewModel: PostAnnounceViewModel?
    
    // MARK: - SheetContentConfigurable Properties
    
    var contentView: UIView { return self }
    
    // MARK: - UI Properties
    
    private let dateView = UICalendarView()
    
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
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    func updateInitialDate() {
        let initialDate: DateComponents?
        
        switch type {
        case .start:
            initialDate = viewModel?.startDaySubject.value
        case .end:
            initialDate = viewModel?.endDaySubject.value
        }
        
        if let selection = dateView.selectionBehavior as? UICalendarSelectionSingleDate {
            selection.setSelected(initialDate, animated: true)
        }
    }
    
    func getSelectedDate() -> DateComponents? {
        return (dateView.selectionBehavior as? UICalendarSelectionSingleDate)?.selectedDate
    }
}

// MARK: - Private Extensions

private extension CalendarModalContentView {
    func setupStyle() {
        dateView.do {
            $0.wantsDateDecorations = false
            $0.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        }
    }
    
    func setupHierarchy() {
        contentView.addSubview(dateView)
    }
    
    func setupLayout() {
        dateView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.verticalEdges.equalToSuperview()
        }
    }
}

// MARK: - UICalendarSelectionSingleDateDelegate Extensions

extension CalendarModalContentView: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        switch type {
        case .start:
            return true
        case .end:
            guard let dateComponents,
                  let startComponents = viewModel?.startDaySubject.value,
                  let startDate = Calendar.current.date(from: startComponents),
                  let selectedDate = Calendar.current.date(from: dateComponents) else {
                return false
            }
            return selectedDate >= startDate
        }
    }
}
