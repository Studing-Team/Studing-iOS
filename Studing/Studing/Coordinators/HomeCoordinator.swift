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
        let homeVC = HomeViewController()
        homeVC.coordinator = self
        navigationController.pushViewController(homeVC, animated: true)
        navigationController.navigationItem.hidesBackButton = true
    }
    
    func pushDetailAnnouce() {
        let annouceListVC = AnnouceListViewController(type: .association)
        
        annouceListVC.hidesBottomBarWhenPushed = true
        
        if let customNav = navigationController as? CustomAnnouceNavigationController {
            customNav.setNavigationType(.announce)
            customNav.setNavigationTitle("학생회 공지 리스트")
        }
        
        navigationController.pushViewController(annouceListVC, animated: true)
    }
    
    func pushDetailBookmarkAnnouce() {
        let annouceListVC = AnnouceListViewController(type: .bookmark)
        annouceListVC.hidesBottomBarWhenPushed = true
        
        if let customNav = navigationController as? CustomAnnouceNavigationController {
            customNav.setNavigationType(.announce)
            customNav.setNavigationTitle("저장한 공지사항을 확인해요")
        }
        
        navigationController.pushViewController(annouceListVC, animated: true)
    }
}
