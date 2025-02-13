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
    private weak var viewModel: PostAnnounceViewModel?
    
    private var selectedDateComponents: DateComponents?
    
    // MARK: - UI Properties
    
    private let dateView = UICalendarView()
        
    // MARK: - Init
        
    init(
        type: PostPickerType,
        viewModel: PostAnnounceViewModel
    ) {
        self.type = type
        self.viewModel = viewModel

        switch type {
        case .start:
            buttonSttyle = .startDay
        case .end:
            buttonSttyle = .endDay
        }
        
        super.init(
            buttonStyle: buttonSttyle
        )
        
        print("CalendarModalViewController init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("CalendarModalViewController deinit")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let initialDate: DateComponents?
        
        switch type {
        case .start:
            initialDate = viewModel?.startDaySubject.value

        case .end:
            initialDate = viewModel?.endDaySubject.value
        }
        
        if let selection = dateView.selectionBehavior as? UICalendarSelectionSingleDate {
            selection.setSelected(initialDate, animated: true)
            updateSelectedDate(initialDate)
        }
    }
}

// MARK: - Private Extensions

private extension CalendarModalViewController {
    func setupStyle() {
        dateView.do {
            $0.wantsDateDecorations = false
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
//        dateView.delegate = self
    }

    func updateSelectedDate(_ dateComponents: DateComponents?) {
        
        guard let dateComponents = dateComponents,
              let viewModel = viewModel else { return }
        
        selectedDateComponents = dateComponents
        
        switch type {
        case .start:
            viewModel.startDaySubject.send(dateComponents)
        case .end:
            viewModel.endDaySubject.send(dateComponents)
        }
    }

    func setupButtonAction() {
        bindingBottomButtonAction { [weak self] in
            guard let self else { return }
            
            if let dateComponents = (self.dateView.selectionBehavior as? UICalendarSelectionSingleDate)?.selectedDate {
                self.updateSelectedDate(dateComponents)
            }
            
            self.dismiss(animated: true)
        }
    }
}

extension CalendarModalViewController: UICalendarSelectionSingleDateDelegate {
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
