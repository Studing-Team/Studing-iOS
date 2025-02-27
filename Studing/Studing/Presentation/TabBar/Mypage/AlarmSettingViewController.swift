//
//  AlarmSettingViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/22/25.
//

import Combine
import UIKit

import SnapKit
import Then

final class AlarmSettingViewController: UIViewController {
    
    // MARK: - Combine Properties
    
    private let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, Never>()
    private let osSettingSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private let alarmSettingViewModel: AlarmSettingViewModel
    weak var coordinator: MypageCoordinator?
    
    // MARK: - UI Properties
    
    private let mainStackView = UIStackView()
    private let alarmInfomationView = AlarmInfomationView()
    private let announceAlarmSettingView = AlarmSettingView()
    
    // MARK: - Init
    
    init(alarmSettingViewModel: AlarmSettingViewModel,
        coordinator: MypageCoordinator) {
        self.alarmSettingViewModel = alarmSettingViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black5
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        bindViewModel()
        
        // 앱이 다시 활성화될 때 알림 상태 체크
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkNotificationStatus),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("AlarmSettingViewController viewWillAppear")
        viewLifeCycleSubject.send(.viewWillAppear)
        
        if let customNav = self.navigationController as? CustomAnnounceNavigationController {
            customNav.setNavigationType(.alarmSetting)
        }
    }
    
    deinit {
        print("AlarmSettingViewController deinit")
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func checkNotificationStatus() {
        viewLifeCycleSubject.send(.viewWillAppear)
    }
}

// MARK: - Private Bind Extensions

private extension AlarmSettingViewController {
    func bindViewModel() {
        let input = AlarmSettingViewModel.Input(
            viewLifeCycleEventAction: viewLifeCycleSubject.eraseToAnyPublisher(),
            osSettingAction: osSettingSubject.eraseToAnyPublisher()
        )
        
        let output = alarmSettingViewModel.transform(input: input)
        
        output.viewLifeCycleEventResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.alarmInfomationView.changeAlarmState(isAlarm: result)
            }
            .store(in: &cancellables)
        
        output.osSettingResult
            .receive(on: DispatchQueue.main)
            .sink { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension AlarmSettingViewController {
    func setupStyle() {
        mainStackView.do {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.spacing = 0
            $0.addArrangedSubviews(alarmInfomationView)
        }
        
        alarmInfomationView.setAlarmSettingAction { [weak self] in
            self?.osSettingSubject.send()
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(mainStackView)
    }
    
    func setupLayout() {
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc private func alarmInfomationViewTappend(_ gesture: UITapGestureRecognizer) {
        osSettingSubject.send()
    }
}
