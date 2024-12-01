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
    
    init(navigationController: UINavigationController,
         parentCoordinator: (any Coordinator)?
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
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
        
        if let customNav = navigationController as? CustomAnnouceNavigationController {
            customNav.setNavigationType(.home)
        }
        
        navigationController.pushViewController(homeVC, animated: true)
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
        
        if let customNav = navigationController as? CustomAnnouceNavigationController {
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
        
        if let customNav = navigationController as? CustomAnnouceNavigationController {
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
        
        if let customNav = navigationController as? CustomAnnouceNavigationController {
            switch type {
            case .announce, .bookmarkAnnounce:
                customNav.setNavigationType(.detail)
                
            case .unreadAnnounce:
                customNav.setNavigationType(.unRead)
                
            }
        }
        
        navigationController.pushViewController(detailAnnouceVC, animated: true)
    }
    
    func presentPostAnnounce() {
        
        let postAnnounceVM = PostAnnounceViewModel(createAnnounceUseCase: CreateAnnounceUseCase(repository: NoticesRepositoryImpl()))
        let postAnnounceVC = PostAnnounceViewController(postAnnounceViewModel: postAnnounceVM, coordinator: self)
        
        // 새로운 CustomAnnouceNavigationController 생성
            let newNav = CustomAnnouceNavigationController(rootViewController: postAnnounceVC)
            newNav.setNavigationType(.post)
        newNav.modalPresentationStyle = .overFullScreen
        
        navigationController.present(newNav, animated: true)
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
