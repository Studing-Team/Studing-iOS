//
//  CalendarModalViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/12/25.
//

import UIKit

import SnapKit
import Then

final class CalendarModalViewController: BaseSheetViewController {
    
    // MARK: - Properties
    
    private let type: PostPickerType
    private weak var viewModel: PostAnnounceViewModel?
    private let contentConfiguration: CalendarModalContentView
    
    // MARK: - Init
    
    init(type: PostPickerType, viewModel: PostAnnounceViewModel) {
        self.type = type
        self.viewModel = viewModel
        
        let content = CalendarModalContentView(type: type, viewModel: viewModel)
        self.contentConfiguration = content
        
        let buttonStyle: ButtonStyle = type == .start ? .startDay : .endDay
        let buttonConfig = SingleButtonConfiguration(buttonStyle: buttonStyle)
        
        super.init(content: content, buttons: buttonConfig)
        
        buttonConfig.setAction { [weak self] in
            guard let self,
                  let dateComponents = self.contentConfiguration.getSelectedDate() else { return }
            
            switch self.type {
            case .start:
                self.viewModel?.startDaySubject.send(dateComponents)
            case .end:
                self.viewModel?.endDaySubject.send(dateComponents)
            }
            
            self.dismiss(animated: true)
        }
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
        print("Push CalendarModalViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentConfiguration.updateInitialDate()
    }
}
