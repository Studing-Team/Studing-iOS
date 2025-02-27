//
//  CustomAnnounceNavigationController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/30/24.
//

import Combine
import UIKit

import SnapKit
import Then

enum NavigationType: Equatable {
    case home
    case announce
    case bookmark
    case detail(isAuthor: Bool)
    case unRead(isAuthor: Bool)
    case post
    case firstCome
    case editPost
    case unReadToHome
    case myPage
    case leftButton
    case alarmSetting
}

protocol AlarmButtonTappedDelegate: AnyObject {
    func didAlarmButtonTapped()
}

final class CustomAnnounceNavigationController: UINavigationController {
    
    // MARK: - Properties
    
    weak var delgate: AlarmButtonTappedDelegate?
    let menuButtonTapped = PassthroughSubject<MenuType, Never>()
    
    private var currentUserAuth: UserAuth?
    private var navigationHeight: CGFloat = 0
    private var currentType: NavigationType = .home {
        didSet {
            updateNavigationVisibility()
        }
    }
    private var menuView: CustomMenuView?
    
    // MARK: - UI Properties
    
    private let customNavigationBar = UIView()
    private let leftButton = UIButton()
    private let rightButtonSectionStackView = UIStackView()
    private let alarmButton = UIButton()
    private let dotMenuButton = UIButton()
    private let titleLabel = UILabel()
    private let safeAreaView: UIView = UIView()
    private let divider = UIView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        
        currentUserAuth = KeychainManager.shared.loadData(key: .userAuthState, type: String.self)
            .flatMap { UserAuth(rawValue: $0) } ?? .unUser
    }
}

private extension CustomAnnounceNavigationController {
    
    /// DefaultNavigationBar를 hidden 시켜주는 함수
    func hideDefaultNavigationBar() {
        navigationBar.isHidden = true
    }
    
    /// navigationBar가 hidden 상태인지 아닌지에 따라 view의 safeArea를 정해주는 함수
    func setupSafeArea(navigationBarHidden: Bool) {
        if navigationBarHidden {
            additionalSafeAreaInsets = UIEdgeInsets(top: 0,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)
        } else {
            additionalSafeAreaInsets = UIEdgeInsets(top: navigationHeight,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)
        }
    }
    
    func setupStyle() {
        customNavigationBar.do {
            $0.backgroundColor = .clear
        }
        
        titleLabel.do {
            $0.font = .interSubtitle1()
            $0.textColor = .black50
        }
        
        leftButton.do {
            $0.setImage(UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)),
                        for: .normal)
            $0.tintColor = .black50
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        
        rightButtonSectionStackView.do {
            $0.axis = .horizontal
            $0.alignment = .trailing
            $0.spacing = 12
        }
        
        alarmButton.do {
            $0.setImage(UIImage(resource: .unSelectAlram), for: .normal)
            $0.setImage(UIImage(resource: .selectAlarm), for: .selected)
            $0.addTarget(self, action: #selector(toggleAlarmButton(_:)), for: .touchUpInside)
        }
        
        dotMenuButton.do {
            $0.setImage(UIImage(resource: .unSelectDotMenu), for: .normal)
            $0.setImage(UIImage(resource: .selectDotMenu), for: .selected)
            $0.addTarget(self, action: #selector(toggleDotMenuButton(_:)), for: .touchUpInside)
        }
        
        divider.do {
            $0.backgroundColor = .black10
        }
    }
    
    func setupDelegate() {
        guard let menuView else { return }
        
        menuView.delegate = self
    }

    // 버튼 상태를 토글하는 메서드
    @objc private func toggleAlarmButton(_ sender: UIButton) {
//        sender.isSelected.toggle() // selected 상태를 반전
        delgate?.didAlarmButtonTapped()
    }

    @objc private func toggleDotMenuButton(_ sender: UIButton) {
        sender.isSelected.toggle() // selected 상태를 반전
        
        // 메뉴가 표시되지 않으면 새로 생성하고, 이미 표시되고 있으면 숨김
        if menuView == nil {
            showMenu()
        } else {
            hideMenu()
        }
    }
    
    private func showMenu() {
        let menuVC = CustomMenuView()
        
        // 메뉴의 초기 상태 설정
        menuVC.alpha = 0
        menuVC.transform = CGAffineTransform(scaleX: 1, y: 0.8)
        
        // 메뉴 뷰를 현재 뷰에 추가
        view.addSubview(menuVC)
        
        // 메뉴의 위치와 크기 설정
        menuVC.snp.makeConstraints {
            $0.top.equalTo(dotMenuButton.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(15)
            $0.width.equalTo(169)
            $0.height.equalTo(82)
        }
        
        UIView.animate(
            withDuration: 0.5, // 애니메이션 시간
            delay: 0, // 지연 시간
            usingSpringWithDamping: 0.6, // 스프링 감쇠 비율 (낮을수록 탄성이 강함)
            initialSpringVelocity: 1, // 초기 속도 (값이 클수록 더 튀는 효과)
            options: [.curveEaseOut], // 애니메이션 옵션
            animations: {
                menuVC.alpha = 1 // 투명도 복원
                menuVC.transform = .identity // 원래 크기로 복원
            },
            completion: nil
        )
        // 메뉴 뷰를 변수에 저장
        menuView = menuVC
        setupDelegate()
    }
    
    private func hideMenu(type: MenuType? = nil) {
        guard let menuVC = menuView else { return }
        
        // 애니메이션으로 메뉴 숨기기
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1,
            options: [.curveEaseIn],
            animations: {
                menuVC.transform = CGAffineTransform(scaleX: 1, y: 0.8) // Y축으로 접히는 효과
                menuVC.alpha = 0 // 투명하게 설정
            },
            completion: { [weak self] _ in
                menuVC.removeFromSuperview()
                self?.menuView = nil // 메뉴 숨김 후 상태 초기화
                
                if let type {
                    self?.menuButtonTapped.send(type)
                }
            }
        )
    }

    func applyRightButtonSection(_ isAuthor: Bool) {
        switch currentUserAuth {
        case .collegeUser, .departmentUser, .universityUser:
            
            resetStackView(rightButtonSectionStackView)
            
            addAlarmButton()
            addDotMenuButton(isAuthor)
            
        case .successUser:
            resetStackView(rightButtonSectionStackView)
            
            addAlarmButton()
        default:
            break
        }
    }
    
    func addAlarmButton() {
        rightButtonSectionStackView.addArrangedSubview(alarmButton)
    }
    
    func addDotMenuButton(_ isAuthor: Bool) {
        if isAuthor {
            rightButtonSectionStackView.addArrangedSubviews(dotMenuButton)
        }
    }
    
    func resetStackView(_ stackView: UIStackView) {
        // 기존 arrangedSubviews 제거
        stackView.arrangedSubviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview() // 스택뷰에서 완전히 제거
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(safeAreaView)
        safeAreaView.addSubviews(customNavigationBar, divider)
        customNavigationBar.addSubviews(leftButton, titleLabel, rightButtonSectionStackView)
    }
    
    private func applyHomeLayout() {
        safeAreaView.snp.remakeConstraints {
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(navigationHeight)
        }
        
        customNavigationBar.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.remakeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func applyDefaultLayout() {
        // 기존 레이아웃
        safeAreaView.snp.remakeConstraints {
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(navigationHeight)
        }
        
        customNavigationBar.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        leftButton.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-8)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.remakeConstraints {
            $0.leading.equalTo(leftButton.snp.trailing).offset(10)
            $0.centerY.equalTo(leftButton)
        }
        
        rightButtonSectionStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func applyDetailLayout() {
        // 디테일 화면용 레이아웃
        safeAreaView.snp.remakeConstraints {
//            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(navigationHeight)
        }
        
        customNavigationBar.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        leftButton.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.remakeConstraints {
            $0.centerX.equalToSuperview()  // 가로 중앙 정렬
            $0.centerY.equalTo(leftButton) // leftButton과 같은 세로선상에 위치
        }
        
        divider.snp.remakeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        rightButtonSectionStackView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        alarmButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        dotMenuButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    private func applyPostLayout() {
        safeAreaView.snp.remakeConstraints {
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(navigationHeight)
        }
        
        customNavigationBar.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        leftButton.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.remakeConstraints {
            $0.centerX.equalToSuperview()  // 가로 중앙 정렬
            $0.centerY.equalTo(leftButton) // leftButton과 같은 세로선상에 위치
        }
        
        divider.snp.remakeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func applyMypageLayout() {
        safeAreaView.snp.remakeConstraints {
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(navigationHeight)
        }
        
        customNavigationBar.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.remakeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        rightButtonSectionStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func applyAlarmSettingLayout() {
        safeAreaView.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(navigationHeight)
        }
        
        customNavigationBar.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(leftButton)
        }
        
        divider.snp.remakeConstraints {
            $0.top.equalTo(customNavigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        leftButton.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
    }
    
    private func applyLeftButtonLayout() {
        safeAreaView.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.snp.topMargin)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(navigationHeight)
        }
        
        customNavigationBar.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        leftButton.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
    }
    
    private func setupLayout() {
        // 초기 레이아웃 설정
        updateNavigationVisibility()
    }
    
    private func updateNavigationVisibility() {
        switch currentType {
        case .home:
            navigationHeight = 56
            customNavigationBar.isHidden = false
            safeAreaView.isHidden = false
            divider.isHidden = true
            leftButton.isHidden = true
            rightButtonSectionStackView.isHidden = true
            setupSafeArea(navigationBarHidden: false)
            
            applyHomeStyle()
            applyHomeLayout()
            
        case .announce, .bookmark:
            navigationHeight = 60
            customNavigationBar.isHidden = false
            safeAreaView.isHidden = false
            divider.isHidden = true
            leftButton.isHidden = false
            rightButtonSectionStackView.isHidden = true
            setupSafeArea(navigationBarHidden: false)
            
            // announce 스타일 적용
            applyAnnounceStyle()
            applyDefaultLayout()
            
        case .detail(let isAuthor):
            navigationHeight = 56
            customNavigationBar.isHidden = false
            safeAreaView.isHidden = false
            leftButton.isHidden = false
            divider.isHidden = false
            rightButtonSectionStackView.isHidden = false
            setupSafeArea(navigationBarHidden: false)
            
            // detail 스타일 적용
            applyDetailStyle()
            applyDetailLayout()
            
            applyRightButtonSection(isAuthor)
//            applyRightButtonSection()
            
        case .unRead(let isAuthor):
            navigationHeight = 56
            customNavigationBar.isHidden = false
            safeAreaView.isHidden = false
            divider.isHidden = false
            leftButton.isHidden = false
            rightButtonSectionStackView.isHidden = false
            setupSafeArea(navigationBarHidden: false)
            
            applyUnReadStyle()
            applyDetailLayout()
            applyRightButtonSection(isAuthor)
            
        case .post, .editPost, .firstCome:
            navigationHeight = 56
            customNavigationBar.isHidden = false
            safeAreaView.isHidden = false
            divider.isHidden = false
            leftButton.isHidden = false
            rightButtonSectionStackView.isHidden = true
            setupSafeArea(navigationBarHidden: false)
            
            leftButton.setImage(UIImage(systemName: "xmark")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)),
                                for: .normal)
            
            // post 스타일 적용
            applyPostStyle()
            applyPostLayout()
            
        case .unReadToHome:
            customNavigationBar.isHidden = true
            safeAreaView.isHidden = true
            divider.isHidden = true
            leftButton.isHidden = true
            rightButtonSectionStackView.isHidden = true
            setupSafeArea(navigationBarHidden: true)
            
        case .myPage:
            navigationHeight = 56
            customNavigationBar.isHidden = false
            safeAreaView.isHidden = false
            divider.isHidden = true
            leftButton.isHidden = true
            rightButtonSectionStackView.isHidden = false
            setupSafeArea(navigationBarHidden: false)
            
            applyMypageStyle()
            applyMypageLayout()
            
        case .leftButton:
            navigationHeight = 56
            customNavigationBar.isHidden = false
            safeAreaView.isHidden = false
            divider.isHidden = true
            leftButton.isHidden = false
            rightButtonSectionStackView.isHidden = true
            setupSafeArea(navigationBarHidden: false)
            
            applyLeftButtontyle()
            applyLeftButtonLayout()
            
        case .alarmSetting:
            navigationHeight = 56
            customNavigationBar.isHidden = false
            safeAreaView.isHidden = false
            divider.isHidden = false
            leftButton.isHidden = false
            rightButtonSectionStackView.isHidden = true
            setupSafeArea(navigationBarHidden: false)
            
            applyAlarmSettingStyle()
            applyAlarmSettingLayout()
        }
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        print("뒤로가기 버튼 동작")
        if currentType == .post || currentType == .editPost || currentType == .firstCome {
            self.dismiss(animated: true)
        } else {
            if case .unRead = currentType {
                AmplitudeManager.shared.trackEvent(AnalyticsEvent.UnreadNotice.back)
            }
            
            if menuView != nil {
                hideMenu()
            }
            
            self.popViewController(animated: true)
        }
    }
    
    private func applyHomeStyle() {
        // announce 스타일 설정
        customNavigationBar.backgroundColor = .clear
        titleLabel.font = .montserratAlternatesBold(size: 28)
        titleLabel.textColor = .black50
        leftButton.tintColor = .black50
    }
    
    private func applyAnnounceStyle() {
        // announce 스타일 설정
        customNavigationBar.backgroundColor = .clear
        titleLabel.font = .interSubtitle1()
        titleLabel.textColor = .black50
        leftButton.tintColor = .black50
    }
    
    private func applyDetailStyle() {
        // detail 스타일 설정
        customNavigationBar.backgroundColor = .black5
        titleLabel.font = .interSubtitle1()
        titleLabel.textColor = .black50
        leftButton.tintColor = .black50
    }
    
    private func applyPostStyle() {
        // detail 스타일 설정
        customNavigationBar.backgroundColor = .black5
        titleLabel.font = .interSubtitle1()
        titleLabel.textColor = .black50
        leftButton.tintColor = .black50
    }
    
    private func applyUnReadStyle() {
        // detail 스타일 설정
        customNavigationBar.backgroundColor = .black5
        titleLabel.font = .interSubtitle1()
        titleLabel.textColor = .black50
        leftButton.tintColor = .black50
    }
    
    private func applyMypageStyle() {
        // detail 스타일 설정
        customNavigationBar.backgroundColor = .clear
        titleLabel.font = .interSubtitle1()
        titleLabel.textColor = .black50
        leftButton.tintColor = .black50
    }
    
    private func applyAlarmSettingStyle() {
        // detail 스타일 설정
        customNavigationBar.backgroundColor = .black5
        titleLabel.font = .interSubtitle1()
        titleLabel.textColor = .black50
        leftButton.tintColor = .black50
    }
    
    private func applyLeftButtontyle() {
        // detail 스타일 설정
        customNavigationBar.backgroundColor = .black5
        leftButton.tintColor = .black50
    }
}

// MARK: - Public Extension

extension CustomAnnounceNavigationController {
    func setNavigationType(_ type: NavigationType) {
        currentType = type
        
        switch type {
        case .announce:
            setNavigationTitle("학생회 공지 리스트")
        case .bookmark:
            setNavigationTitle("저장한 공지사항을 확인해요")
        case .detail:
            setNavigationTitle("공지사항")
        case .home:
            setNavigationTitle("Studing")
        case .post:
            setNavigationTitle("공지사항 작성")
        case .firstCome:
            setNavigationTitle("선착순 이벤트 등록")
        case .editPost:
            setNavigationTitle("공지사항 수정")
        case .myPage:
            setNavigationTitle("마이페이지")
        case .unRead, .unReadToHome, .leftButton:
            setNavigationTitle("")
        case .alarmSetting:
            setNavigationTitle("알림 설정")
        }
    }
    
    func setNavigationTitle(_ title: String) {
        titleLabel.text = title
    }

    func addDotMenu(_ isAuthor: Bool) {
        addDotMenuButton(isAuthor)
    }
    
    func updateAlarmMenu(_ isAlarm: Bool) {
        alarmButton.isSelected = isAlarm
    }
}

// MARK: - Public Delegate Extension

extension CustomAnnounceNavigationController: MenuButtonActionDelegate {
    func menuButtonTapAction(type: MenuType) {
        self.dotMenuButton.isSelected.toggle()
        
        hideMenu(type: type)
    }
}
