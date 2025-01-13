//
//  CalendarModalViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/12/25.
//

import UIKit

import SnapKit
import Then

final class CalendarModalViewController: SingleButtonSheetViewController {
    
    // MARK: - Properties

    private var type: PostPickerType
    private var buttonSttyle: ButtonStyle
    
    // MARK: - UI Properties
    
    private let dateView = UICalendarView()
        
    // MARK: - Init
        
    init(type: PostPickerType) {
        self.type = type
        
        switch type {
        case .start:
            buttonSttyle = .startDay
        case .end:
            buttonSttyle = .endDay
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

private extension CalendarModalViewController {
    func setupStyle() {
        dateView.do {
            $0.wantsDateDecorations = true // Custom 을 위한 속성
            $0.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        }
    }
    
    func setupHierarchy() {
        self.contentAreaView.addSubviews(dateView)
    }
    
    func setupLayout() {
        dateView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    func setupDelegate() {
        dateView.delegate = self
    }
}

extension CalendarModalViewController: UICalendarViewDelegate {
//    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
//
//    }
}


extension CalendarModalViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
        
//        guard let dateComponents = dateComponents else { return }
//        selectedDateSubject.send(dateComponents)
    }
}
