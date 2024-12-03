//
//  CustomAnnouceNavigationController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/30/24.
//

import UIKit

import SnapKit
import Then

enum NavigationType {
    case home
    case announce
    case bookmark
    case detail
    case unRead
    case post
    case unReadToHome
    case myPage
    case leftButton
}

final class CustomAnnouceNavigationController: UINavigationController {
    
    // MARK: - Properties
    
    private var navigationHeight: CGFloat = 0
    private var currentType: NavigationType = .home {
        didSet {
            updateNavigationVisibility()
        }
    }
    
    // MARK: - UI Properties
    
    private let customNavigationBar = UIView()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
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
    }
}

private extension CustomAnnouceNavigationController {
    
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
        
        rightButton.do {
            $0.setImage(UIImage(resource: .alarm), for: .normal)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .black50
            $0.isHidden = true
        }
        
        divider.do {
            $0.backgroundColor = .black10
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(safeAreaView)
        safeAreaView.addSubviews(customNavigationBar, divider)
        customNavigationBar.addSubviews(leftButton, titleLabel, rightButton)
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
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func applyDetailLayout() {
        // 디테일 화면용 레이아웃
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
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
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
            rightButton.isHidden = true
            setupSafeArea(navigationBarHidden: false)
            
            applyHomeStyle()
            applyHomeLayout()
            
        case .announce, .bookmark:
            navigationHeight = 60
            customNavigationBar.isHidden = false
            safeAreaView.isHidden = false
            divider.isHidden = true
            leftButton.isHidden = false
            rightButton.isHidden = true
            setupSafeArea(navigationBarHidden: false)
            
            // announce 스타일 적용
            applyAnnounceStyle()
            applyDefaultLayout()
            
        case .detail:
            navigationHeight = 50
            customNavigationBar.isHidden = false
            safeAreaView.isHidden = false
            leftButton.isHidden = false
            divider.isHidden = false
            rightButton.isHidden = true
            setupSafeArea(navigationBarHidden: false)
            
            // detail 스타일 적용
            applyDetailStyle()
            applyDetailLayout()
            
        case .unRead:
            navigationHeight = 56
            customNavigationBar.isHidden = false
            safeAreaView.isHidden = false
            divider.isHidden = false
            leftButton.isHidden = false
            rightButton.isHidden = true
            setupSafeArea(navigationBarHidden: false)
            
            applyUnReadStyle()
            applyDetailLayout()
            
        case .post:
            navigationHeight = 56
            customNavigationBar.isHidden = false
            safeAreaView.isHidden = false
            divider.isHidden = false
            leftButton.isHidden = false
            rightButton.isHidden = true
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
            rightButton.isHidden = true
            setupSafeArea(navigationBarHidden: true)
            
        case .myPage:
            navigationHeight = 56
            customNavigationBar.isHidden = false
            safeAreaView.isHidden = false
            divider.isHidden = true
            leftButton.isHidden = true
            rightButton.isHidden = false
            setupSafeArea(navigationBarHidden: false)
            
            applyMypageStyle()
            applyMypageLayout()
            
        case .leftButton:
            navigationHeight = 56
            customNavigationBar.isHidden = false
            safeAreaView.isHidden = false
            divider.isHidden = true
            leftButton.isHidden = false
            rightButton.isHidden = true
            setupSafeArea(navigationBarHidden: false)
            
            applyLeftButtontyle()
            applyLeftButtonLayout()
        }
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        print("뒤로가기 버튼 동작")
        if currentType == .post {
            self.dismiss(animated: true)
        } else {
            if currentType == .unRead {
                AmplitudeManager.shared.trackEvent(AnalyticsEvent.UnreadNotice.back)
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
    
    private func applyLeftButtontyle() {
        // detail 스타일 설정
        customNavigationBar.backgroundColor = .black5
        leftButton.tintColor = .black50
    }
}

// MARK: - Public Methods
extension CustomAnnouceNavigationController {
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
        case .myPage:
            setNavigationTitle("마이페이지")
        case .unRead, .unReadToHome, .leftButton:
            setNavigationTitle("")
        }
    }
    
    func setNavigationTitle(_ title: String) {
        titleLabel.text = title
    }
}
