//
//  AnnounceAlarmSettingViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/5/25.
//

import Combine
import UIKit

import SnapKit
import Then

final class AnnounceAlarmSettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var selectedDateComponents: DateComponents?
    private var leftButtonAction: (() -> Void)?
    private var rightButtonAction: (() -> Void)?
    
    private let announceAlarmSettingViewModel: AnnounceAlarmSettingViewModel
    
    // MARK: - Combine Properties
     
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let alertBackgroundView = UIView()
    private let titleStackView = UIStackView()
    private let periodStackView = UIStackView()
    private let bottomStackView = UIStackView()
    
    private var mainTitleLabel = UILabel()
    private var subTitleLabel = UILabel()
    
    private var modalView: AlarmInputPeriodView?
    
    private let alarmDayView = PeriodSettingView(type: .days)
    private let alarmTimeView = PeriodSettingView(type: .times)
    
    private let leftButton = CustomButton(buttonStyle: .cancel)
    private let rightButton = CustomButton(buttonStyle: .confirm(type: .normal))
    
    // MARK: - init
    
    init(
        announceAlarmSettingViewModel: AnnounceAlarmSettingViewModel
    ) {
        self.announceAlarmSettingViewModel = announceAlarmSettingViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        print("AnnounceAlarmSettingViewController deinit")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black.withAlphaComponent(0.65)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
        setupGesture()
    }
}

// MARK: - Private Extensions

private extension AnnounceAlarmSettingViewController {
    func bindViewModel() {
        let input = AnnounceAlarmSettingViewModel.Input(
            confirmButtonTap: rightButton.tapPublisher
        )
        
        let output = announceAlarmSettingViewModel.transform(input: input)
        
        output.alarmStateResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateTitle(state)
            }
            .store(in: &cancellables)
        
        output.confirmButtonResult
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { Bool in
                self.dismiss(animated: false)
            })
            .store(in: &cancellables)
        
        output.alarmDayResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alarmDay in
                self?.alarmDayView.bindingTitle(title: alarmDay)
            }
            .store(in: &cancellables)
        
        output.alarmTimeResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alarmTime in
                self?.alarmTimeView.bindingTitle(title: alarmTime)
            }
            .store(in: &cancellables)
    }
    
    
    @objc private func dismissModalView(_ gesture: UITapGestureRecognizer) {
        if let modalView {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseOut,
                           animations: {
                
                self.alertBackgroundView.snp.remakeConstraints {
                    $0.center.equalToSuperview()
                    $0.horizontalEdges.equalToSuperview().inset(38)
                }
                
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: .curveEaseInOut,
                           animations: {
                
                modalView.frame.origin.y = UIScreen.main.bounds.height
            }, completion: {_ in
                self.dismissModal()
            })
        } else {
            self.dismiss(animated: false)
        }
    }
    
    func dismissModal() {
        guard let modalView else { return }
        modalView.removeFromSuperview()
        
        self.modalView = nil
    }
    
    @objc private func dayViewTappend(_ gesture: UITapGestureRecognizer) {
        if modalView == nil && announceAlarmSettingViewModel.alarmStateSubject.value == .unSelected {
            updateLayout(.calendar)
            
            modalView = AlarmInputPeriodView(alarmPeriodType: .calendar)
            
            let initialTime = announceAlarmSettingViewModel.alarmDaySubject.value
            
            modalView?.bindingDay(initialTime)
            
            guard let modalView else { return }
            
            self.view.addSubview(modalView)
            
            modalView.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(15)
                $0.top.equalTo(self.view.snp.bottom)
                $0.height.equalTo(self.view.convertByHeightRatio(411))
            }
            
            self.view.layoutIfNeeded()

            UIView.animate(withDuration: 0.45, // ✅ iOS 모달 느낌에 맞춰 속도를 0.6초로 조정
                           delay: 0,
                           usingSpringWithDamping: 0.95, // ✅ 스프링 효과 추가 (0.5~0.8 추천)
                           initialSpringVelocity: 0.9, // ✅ 처음 속도 조절 (0.5~1.0 추천)
                           options: [.curveEaseOut], // ✅ 자연스럽게 감속하도록 설정
                           animations: {
                modalView.snp.updateConstraints {
                    $0.top.equalTo(self.view.snp.bottom).offset(-(self.view.convertByHeightRatio(411) + self.view.safeAreaInsets.bottom))
                    $0.horizontalEdges.equalToSuperview().inset(15)
                    $0.height.equalTo(self.view.convertByHeightRatio(411))
                }
                
                self.view.layoutIfNeeded()
            })
            
            
            setupDayViewBottomButtonAction()
        }
    }
    
    @objc private func timeViewTappend(_ gesture: UITapGestureRecognizer) {
        if modalView == nil && announceAlarmSettingViewModel.alarmStateSubject.value == .unSelected {
            updateLayout(.time)
            
            modalView = AlarmInputPeriodView(alarmPeriodType: .time)
            
            let initialTime: DateComponents? = announceAlarmSettingViewModel.alarmTimeSubject.value
            
            if let initialTime, let hour = initialTime.hour, let minute = initialTime.minute {
                let firstIndex: Int = hour > 12 ? 1 : 0
                let secondIndex: Int = hour > 12 ? hour % 12 : hour
                modalView?.bindingTimePicker(firstIndex, secondIndex, minute)
            }
            
            guard let modalView else { return }
 
            self.view.addSubview(modalView)
            
            // 1. 먼저 초기 제약조건 설정
            modalView.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(15)
                $0.top.equalTo(self.view.snp.bottom) // 시작 위치는 화면 밖
                $0.height.equalTo(self.view.convertByHeightRatio(300))
            }
            
            self.view.layoutIfNeeded() // 초기 레이아웃 적용
            
            UIView.animate(withDuration: 0.45,
                           delay: 0,
                           usingSpringWithDamping: 0.95,
                           initialSpringVelocity: 0.9,
                           options: [.curveEaseOut],
                           animations: {
                modalView.snp.remakeConstraints {
                    $0.horizontalEdges.equalToSuperview().inset(15)
                    $0.top.equalTo(self.view.snp.bottom).offset(-(self.view.convertByHeightRatio(300) + self.view.safeAreaInsets.bottom))
                    $0.height.equalTo(self.view.convertByHeightRatio(300))
                }
                
                self.view.layoutIfNeeded()
            })
            
            setuptimeViewBottomButtonAction()
        }
    }
    
    func setupDayViewBottomButtonAction() {
        guard let modalView else { return }
        print("modalView 현재위치2", modalView.frame.origin.y)
        modalView.bindingBottomButtonAction { [weak self] in
            
            guard let self else { return }
            
            if let dateCompocnents = (modalView.dateView.selectionBehavior as? UICalendarSelectionSingleDate)?.selectedDate {
                
                self.announceAlarmSettingViewModel.alarmDaySubject.send(dateCompocnents)
                
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.5,
                               options: .curveEaseOut,
                               animations: {
                    
                    self.alertBackgroundView.snp.remakeConstraints {
                        $0.center.equalToSuperview()
                        $0.horizontalEdges.equalToSuperview().inset(38)
                    }
                    
                    self.view.layoutIfNeeded()
                })
                
                UIView.animate(withDuration: 0.25,
                               delay: 0,
                               options: .curveEaseInOut,
                               animations: {
 
                    modalView.snp.remakeConstraints {
                        $0.bottom.equalToSuperview().offset(UIScreen.main.bounds.height)
                    }
                    
                    self.view.layoutIfNeeded()
                    
                }, completion: { _ in
                    self.dismissModal()
                })
            }
        }
    }
    
    func setuptimeViewBottomButtonAction() {
        
        guard let modalView else { return }
        
        modalView.bindingBottomButtonAction { [weak self] in
            
            guard let self else { return }
            
            let timeComponents = modalView.timePickerView.selectedTimeComponents()
            self.announceAlarmSettingViewModel.alarmTimeSubject.send(timeComponents)
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseOut,
                           animations: {
                
                self.alertBackgroundView.snp.remakeConstraints {
                    $0.center.equalToSuperview()
                    $0.horizontalEdges.equalToSuperview().inset(38)
                }
                
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: .curveEaseInOut,
                           animations: {
                
                modalView.snp.remakeConstraints {
                    $0.bottom.equalToSuperview().offset(UIScreen.main.bounds.height)
                }
                
                self.view.layoutIfNeeded()
                
            }, completion: {_ in
                self.dismissModal()
            })
        }
    }
    
    func setupStyle() {
        alertBackgroundView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
        }
        
        titleStackView.do {
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .fillProportionally
        }
        
        periodStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.layoutMargins = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
            $0.isLayoutMarginsRelativeArrangement = true
        }

        bottomStackView.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        
        mainTitleLabel.do {
            $0.text = "알림 설정"
            $0.numberOfLines = 0
            $0.textColor = .black50
            $0.font = .interSubtitle1()
            $0.textAlignment = .center
        }
        
        subTitleLabel.do {
            $0.text = "리마인드 푸쉬 알림을 받고 싶은\n날짜와 시간을 설정해주세요!"
            $0.textColor = .black30
            $0.numberOfLines = 2
            $0.font = .interBody1()
            $0.textAlignment = .center
        }
        
        alarmDayView.do {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dayViewTappend)))
        }
        
        alarmTimeView.do {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(timeViewTappend)))
        }
        
        leftButton.do {
            $0.buttonAction = {
                self.dismiss(animated: false)
            }
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(alertBackgroundView)

        alertBackgroundView.addSubviews(titleStackView, periodStackView, bottomStackView)
        
        titleStackView.addArrangedSubviews(mainTitleLabel, subTitleLabel)
        periodStackView.addArrangedSubviews(alarmDayView, alarmTimeView)
        bottomStackView.addArrangedSubviews(leftButton, rightButton)
    }
    
    func setupLayout() {
        alertBackgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(38)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        periodStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.top.equalTo(periodStackView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(38)
        }
        
        alarmDayView.snp.makeConstraints {
            $0.width.equalTo(142)
        }
        
        alarmTimeView.snp.makeConstraints {
            $0.width.equalTo(78)
        }
    }
    
    func setupDelegate() {
        
    }
    
//    func setupBottonButtonAction() {
//        
//        guard let modalView else { return }
//        
//        if announceAlarmSettingViewModel.alarmStateSubject.value == .{
//            
//        }
//    
//        modalView.bindingBottomButtonAction { [weak self] in
//            if let dateCompocnents = (modalView.dateView.selectionBehavior as? UICalendarSelectionSingleDate)?.selectedDate {
//                
//                self?.alarmDayView.bindingTitle(title: dateCompocnents.convertToStringDayFormat())
//            }
//        }
//    }
    
    func updateLayout(_ type: AlarmPeriodType) {
        UIView.animate(withDuration: 0.45,
                       delay: 0,
                       usingSpringWithDamping: 0.95,
                       initialSpringVelocity: 0.9,
                       options: .curveEaseOut,
                       animations: {
            
            self.alertBackgroundView.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(self.view.convertByHeightRatio((type == .calendar ? 108 : 237)))
                $0.horizontalEdges.equalToSuperview().inset(38)
            }
            
            self.view.layoutIfNeeded()
        })
    }
    
    func updateTitle(_ state: AlarmState) {
        mainTitleLabel.text = state.mainTitle
        subTitleLabel.text = state.subTitle
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModalView))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupBottomButtonAction() {
        
    }
}

// MARK: - UICalendarSelectionSingleDateDelegate

extension AnnounceAlarmSettingViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension AnnounceAlarmSettingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == view
    }
}


//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//#Preview("AnnounceAlarmSettingViewController - iPhone 13 mini") {
//    AnnounceAlarmSettingViewController(announceAlarmSettingViewModel: AnnounceAlarmSettingViewModel)
//        .showPreview()
//}
//#endif
