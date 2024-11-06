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
        let homeVC = HomeViewController(coordinator: self)
        
        if let customNav = navigationController as? CustomAnnouceNavigationController {
            customNav.setNavigationType(.home)
        }
        
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func pushAnnouceList() {
        let annouceListVC = AnnouceListViewController(type: .association, coordinator: self)
        
        annouceListVC.hidesBottomBarWhenPushed = true
        
        if let customNav = navigationController as? CustomAnnouceNavigationController {
            customNav.setNavigationType(.announce)
        }
        
        navigationController.pushViewController(annouceListVC, animated: true)
    }
    
    func pushBookmarkList() {
        let annouceListVC = AnnouceListViewController(type: .bookmark, coordinator: self)
        annouceListVC.hidesBottomBarWhenPushed = true
        
        if let customNav = navigationController as? CustomAnnouceNavigationController {
            customNav.setNavigationType(.announce)
            customNav.setNavigationTitle("저장한 공지사항을 확인해요")
        }
        
        navigationController.pushViewController(annouceListVC, animated: true)
    }
    
    func pushDetailAnnouce() {
        let detailAnnouceVC = DetailAnnouceViewController(type: .bookmarkAnnouce, coordinator: self)
        detailAnnouceVC.hidesBottomBarWhenPushed = true
        
        if let customNav = navigationController as? CustomAnnouceNavigationController {
            customNav.setNavigationType(.detail)
        }
        
        navigationController.pushViewController(detailAnnouceVC, animated: true)
    }
}
