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
    
    var childCoordinators: [any Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeVM = HomeViewModel(
            associationLogoUseCase: AssociationLogoUseCase(repository: HomeRepositoryImpl()),
            unreadAssociationUseCase: UnreadAssociationUseCase(repository: HomeRepositoryImpl()),
            unreadAssociationAnnouceCountUseCase: UnreadAssociationAnnounceCountUseCase(repository: HomeRepositoryImpl()),
            recentAnnouceUseCase: RecentAnnounceUseCase(repository: HomeRepositoryImpl()),
            bookmarkAnnouceUseCase: BookmarkAnnounceListUseCase(repository: HomeRepositoryImpl())
        )
        
        let homeVC = HomeViewController(homeViewModel: homeVM, coordinator: self)
        
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
    
    func pushDetailAnnouce() {
        let detailAnnouceVC = DetailAnnounceViewController(type: .bookmarkAnnouce, coordinator: self)
        detailAnnouceVC.hidesBottomBarWhenPushed = true
        
        if let customNav = navigationController as? CustomAnnouceNavigationController {
            customNav.setNavigationType(.detail)
        }
        
        navigationController.pushViewController(detailAnnouceVC, animated: true)
    }
}
