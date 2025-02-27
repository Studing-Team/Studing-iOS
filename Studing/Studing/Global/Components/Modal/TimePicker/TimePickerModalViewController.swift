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

final class TimePickerModalViewController: BaseSheetViewController {
    
    // MARK: - Properties
    
    private var type: PostPickerType
    private weak var viewModel: PostAnnounceViewModel?
    private let contentConfiguration: TimePickerModalContentView
    
    // MARK: - Init
        
    init(
        type: PostPickerType,
        viewModel: PostAnnounceViewModel
    ) {
        self.type = type
        self.viewModel = viewModel
        let content = TimePickerModalContentView(type: type, viewModel: viewModel)
        self.contentConfiguration = content
        
        let buttonConfig = SingleButtonConfiguration(buttonStyle: type == .start ? .startTime: .endTime)
        
        super.init(content: content, buttons: buttonConfig)
        
        buttonConfig.setAction { [weak self] in
            guard let self else { return }
            switch self.type {
            case .start:
                self.viewModel?.startTimeSubject.send(self.contentConfiguration.timePickerView.selectedTimeComponents())
            case .end:
                self.viewModel?.endTimeSubject.send(self.contentConfiguration.timePickerView.selectedTimeComponents())
            }
            
            self.dismiss(animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("TimePickerModalViewController deinit")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Push TimePickerModalViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentConfiguration.updateInitialDate()
    }
}
