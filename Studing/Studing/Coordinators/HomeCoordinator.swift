//
//  HomeCoordinator.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import UIKit

final class HomeCoordinator: Coordinator {
    typealias NavigationControllerType = UINavigationController
    var navigationController: UINavigationController
    weak var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []

    private var currentPostAnnounceVM: PostAnnounceViewModel?
    
    init(navigationController: UINavigationController,
         parentCoordinator: (any Coordinator)?
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    deinit {
        DeepLinkNavigator.shared.removeCoordinator(self)
    }

    func start() {
        let userAuth = KeychainManager.shared.loadData(key: .userAuthState, type: String.self)
            .flatMap { UserAuth(rawValue: $0) } ?? .unUser
        
        print("전달된 값:", userAuth)
        
        let homeVM = HomeViewModel(
            associationLogoUseCase: AssociationLogoUseCase(repository: HomeRepositoryImpl()),
            unreadAssociationUseCase: UnreadAssociationUseCase(repository: HomeRepositoryImpl()),
            unreadAssociationAnnouceCountUseCase: UnreadAssociationAnnounceCountUseCase(repository: HomeRepositoryImpl()),
            recentAnnouceUseCase: RecentAnnounceUseCase(repository: HomeRepositoryImpl()),
            bookmarkAnnouceUseCase: BookmarkAnnounceListUseCase(repository: HomeRepositoryImpl())
        )
        
        let homeVC = HomeViewController(
            homeViewModel: homeVM,
            coordinator: self,
            userAuth: userAuth
        )
        
        if userAuth == .failureUser || userAuth == .unUser {
            homeVC.hidesBottomBarWhenPushed = true
        }
        
        if let customNav = navigationController as? CustomAnnounceNavigationController {
            customNav.setNavigationType(.home)
        }
        
        navigationController.pushViewController(homeVC, animated: true)
        
        DeepLinkNavigator.shared.setActiveCoordinator(self)
    }
    
    func pushAnnouceList(_ associationName: String) {
        print("이동하는 Name:", associationName)
        let announceListVM = AnnounceListViewModel(
            type: .association, associationLogoUseCase: AssociationLogoUseCase(repository: HomeRepositoryImpl()),
            allAnnounceListUseCase: AllAnnounceListUseCase(repository: NoticesRepositoryImpl()),
            allAssociationAnnounceListUseCase: AllAssociationAnnounceListUseCase(repository: NoticesRepositoryImpl()), assicationName: associationName
        )
        
        let annouceListVC = AnnounceListViewController(
            type: .association,
            assicationName: associationName,
            announceViewModel: announceListVM,
            coordinator: self
        )
        
        annouceListVC.hidesBottomBarWhenPushed = true
        
        if let customNav = navigationController as? CustomAnnounceNavigationController {
            customNav.setNavigationType(.announce)
        }
        
        navigationController.pushViewController(annouceListVC, animated: true)
    }
    
    func pushBookmarkList() {
        let announceListVM = AnnounceListViewModel(
            type: .bookmark,
            associationLogoUseCase: AssociationLogoUseCase(repository: HomeRepositoryImpl()),
            allAnnounceListUseCase: AllAnnounceListUseCase(repository: NoticesRepositoryImpl()),
            allAssociationAnnounceListUseCase: AllAssociationAnnounceListUseCase(repository: NoticesRepositoryImpl()),
            bookmarkAssociationAnnounceListUseCase: BookmarkAssociationAnnounceListUseCase(repository: NoticesRepositoryImpl())
        )
        
        let annouceListVC = AnnounceListViewController(
            type: .bookmark,
            announceViewModel: announceListVM,
            coordinator: self
        )
        
        annouceListVC.hidesBottomBarWhenPushed = true
        
        if let customNav = navigationController as? CustomAnnounceNavigationController {
            customNav.setNavigationType(.announce)
            customNav.setNavigationTitle("저장한 공지사항을 확인해요")
        }
        
        navigationController.pushViewController(annouceListVC, animated: true)
    }
    
    func pushDetailAnnouce(type: DetailAnnounceType, announceId: Int? = nil, selectedAssociationType: String? = nil, unReadCount: Int? = nil) {
        
        let repository = NoticesRepositoryImpl()
        let viewModel: DetailAnnouceViewModel
            
        switch type {
        case .announce, .bookmarkAnnounce:
            viewModel = .createDetailViewModel(
                type: type,
                selectedNoticeId: announceId,
                repository: repository
            )
            
        case .unreadAnnounce:
            viewModel = .createUnreadViewModel(
                type: type,
                selectedNoticeId: announceId,
                selectedAssociationType: selectedAssociationType,
                repository: repository,
                unReadCount: unReadCount
            )
        }
        
        let detailAnnouceVC = DetailAnnounceViewController(
            type: type,
            detailAnnouceViewModel: viewModel,
            coordinator: self
        )
        
        detailAnnouceVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailAnnouceVC, animated: true)
    }

    func presentPostAnnounce(postType: PostType,
                             postDisplayType: PostDisplayType,
                             noticeId: Int? = nil,
                             content: EditAnnounceContent? = nil,
                             postOptionType: PostOptionType? = nil
    ) {
        switch postType {
        case .create:
            self.currentPostAnnounceVM =  PostAnnounceViewModel(
                createAnnounceUseCase: CreateAnnounceUseCase(repository: NoticesRepositoryImpl()),
                type: .create,
                postOptionType: postDisplayType == .announce ? .basic : .firstCome
            )
            
        case .edit:
            guard let postOptionType else { return }
            
            self.currentPostAnnounceVM =  PostAnnounceViewModel(
                editAnnounceUseCase: EditPostAnnounceUseCase(repository: NoticesRepositoryImpl()),
                type: .edit, 
                postOptionType: postOptionType
            )
        }

        guard let postAnnounceVM = self.currentPostAnnounceVM else { return }
        
        let postAnnounceVC = PostAnnounceViewController(
            postType: postType,
            postDisplayType: postDisplayType,
            postAnnounceViewModel: postAnnounceVM,
            coordinator: self
        )
        
        // 새로운 CustomAnnouceNavigationController 생성
        let newNav = CustomAnnounceNavigationController(rootViewController: postAnnounceVC)
        newNav.setNavigationType(postDisplayType == .announce ? .post : .firstCome)
        newNav.modalPresentationStyle = .overFullScreen
        
        navigationController.present(newNav, animated: true)
        
        if let content, let noticeId {
            postAnnounceVM.editContent(noticeId: noticeId, content: content)
        }
    }
    
    func presentPostSection() {
        let postSelectTypeModalVC = PostSelectTypeModalViewController(
            coordinator: self,
            firstSectionTap: {
                self.presentPostAnnounce(postType: .create, postDisplayType: .firstCome)
            },
            announceSectionTap: {
                self.presentPostAnnounce(postType: .create, postDisplayType: .announce)
            }
        )

        if let sheet = postSelectTypeModalVC.sheetPresentationController {
            sheet.detents = [
                .custom { _ in
                    return 283 * (UIScreen.main.bounds.height / 812)
                }
            ]
            
            postSelectTypeModalVC.view.backgroundColor = .clear
            postSelectTypeModalVC.modalPresentationStyle = .pageSheet
        }
        navigationController.present(postSelectTypeModalVC, animated: true)
    }
    
    func presentCalendarModal(type: PeriodType) {
        guard let topMostVC = navigationController.presentedViewController else { return }
        guard let postAnnounceVM = self.currentPostAnnounceVM else { return }
        var calendarModalVC: UIViewController
        
        switch type {
        case .startDay:
            calendarModalVC = CalendarModalViewController(
                type: .start, 
                viewModel: postAnnounceVM
            )
            
        case .startTime:
            calendarModalVC = TimePickerModalViewController(
                type: .start, 
                viewModel: postAnnounceVM
            )
            
        case .endDay:
            calendarModalVC = CalendarModalViewController(
                type: .end, 
                viewModel: postAnnounceVM
            )
            
        case .endTime:
            calendarModalVC = TimePickerModalViewController(
                type: .end, 
                viewModel: postAnnounceVM
            )
        }
        
        if let sheet = calendarModalVC.sheetPresentationController {
            sheet.detents = [
                .custom { _ in
                    switch type {
                    case .startDay, .endDay:
                        return 411 * (UIScreen.main.bounds.height / 812)
                    case .startTime, .endTime:
                        return 300 * (UIScreen.main.bounds.height / 812)
                    }
                }
            ]
        }
        
        calendarModalVC.modalPresentationStyle = .pageSheet
        topMostVC.present(calendarModalVC, animated: true)
    }
    
    func presentFirstComeRankModal(noticeId: Int) {
        
        let firstComeModalVM = FirstComeModalViewModel(noticeId: noticeId, firstComeRankingsUseCase: FirstComeRankingsUseCase(repository: NoticesRepositoryImpl()))
        
        let firstComeModalVC = FirstComeModalViewController(firstComeModalViewModel: firstComeModalVM)
        
        if let sheet = firstComeModalVC.sheetPresentationController {
            sheet.detents = [
                .custom { _ in
                    return 609 * (UIScreen.main.bounds.height / 812)
                }
            ]
        }
        
        firstComeModalVC.modalPresentationStyle = .pageSheet
        navigationController.present(firstComeModalVC, animated: true)
    }
    
    func presentAnnounceAlarmSetting(noticeId: Int, alarmData: AlarmSettingData) {
        
        let announceAlarmSettingVM = AnnounceAlarmSettingViewModel(
            noticeId: noticeId,
            alarmData: alarmData
        )
        
        let announceAlarmSettingVC = AnnounceAlarmSettingViewController(
            announceAlarmSettingViewModel: announceAlarmSettingVM)
        
        announceAlarmSettingVC.modalPresentationStyle = .overFullScreen
        navigationController.present(announceAlarmSettingVC, animated: false)
    }
    
    func presentDetailImagePageView(index: Int, imageUrls: [String]) {
        
        let imagePageVC = ImagePageViewController(index: index, imageUrls: imageUrls)
        imagePageVC.modalPresentationStyle = .overFullScreen
        
        navigationController.present(imagePageVC, animated: false)
    }
    
    func pushToReSubmit() {
        let signUpNavigationController = CustomSignUpNavigationController()
        let signUpCoordinator = SignUpCoordinator(navigationController: signUpNavigationController)
        
        // Child Coordinator로 추가
        childCoordinators.append(signUpCoordinator)
        signUpCoordinator.parentCoordinator = self
        signUpCoordinator.delegate = self
        
        // Delegate 설정
        signUpNavigationController.signUpDelegate = self

        signUpNavigationController.modalPresentationStyle = .overFullScreen

        // 설정된 화면과 함께 present
        navigationController.present(signUpNavigationController, animated: true)
        
        signUpCoordinator.pushAuthUniversityView(type: .reSubmit)
    }
    
    func pushAllReadAnnounce() {
        let allReadAnnounceVC = AllReadAnnounceViewController(coordinator: self)
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.pushViewController(allReadAnnounceVC, animated: true)
    }
    
    // Child Coordinator 정리
    func removeChildCoordinator(_ child: any Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }
    
    func popToHome() {
        // 네비게이션 스택의 뷰컨트롤러들 중에서 HomeViewController를 찾음
        if let homeVC = navigationController.viewControllers.first(where: { $0 is HomeViewController }) {
            // HomeViewController까지 pop
            navigationController.popToViewController(homeVC, animated: true)
        }
    }
    
    func comfirmAuthUser() {
        // parent chain을 통해 AppCoordinator 찾아서 직접 호출
        if let appCoordinator = findParentCoordinator(ofType: AppCoordinator.self) {
            appCoordinator.moveToLoginFlow()
        }
    }
    
    // 특정 타입의 parent coordinator를 찾는 유틸리티 메서드
    private func findParentCoordinator<T: Coordinator>(ofType type: T.Type) -> T? {
        var current = parentCoordinator
        
        while let coordinator = current {
            if let targetCoordinator = coordinator as? T {
                return targetCoordinator
            }
            current = coordinator.parentCoordinator
        }
        
        return nil
    }
}

// Delegate 처리
extension HomeCoordinator: SignUpCoordinatorDelegate {
    func didSignUpFinishFlow(_ coordinator: SignUpCoordinator) {
        // SignUp 플로우 종료 시
        navigationController.dismiss(animated: true)
        removeChildCoordinator(coordinator)
        
        // 필요한 경우 화면 갱신
        start()
    }
}


extension HomeCoordinator: CustomSignUpNavigationControllerDelegate {
    func navigationControllerDidTapClose(_ navigationController: CustomSignUpNavigationController) {
        navigationController.dismiss(animated: true) {
            // Child coordinator 정리
            if let signUpCoordinator = self.childCoordinators.first(where: { $0 is SignUpCoordinator }) as? SignUpCoordinator {
                self.removeChildCoordinator(signUpCoordinator)
            }
        }
    }
}

extension HomeCoordinator: DeepLinkCoordinator {
    func navigate(to destination: DeepLinkDestination, data: Any?) -> Bool {
        switch destination {
        case .notice(let id):
            print("🚀 Deep Link 선택: \(String(describing: id)) 공지사항")
            pushDetailAnnouce(type: .announce, announceId: id)
            return true
        default:
            return false
        }
    }
    
    func coordinatorType() -> CoordinatorType {
        return .home
    }
}
