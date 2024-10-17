//
//  TabBarCoordinator.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import UIKit

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
}

final class TabBarCoordinator: TabCoordinatorProtocol {
    typealias NavigationControllerType = UINavigationController
    
    var tabBarController: UITabBarController
    var navigationController: NavigationControllerType
    var childCoordinators: [any Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = CustomTabBarViewController()
//        super.init()
    }
  
    func start() {
        let pages: [TabBarItemType] = [.home, .store, .mypage]
        
        let viewControllers = pages.map { createTabController($0) }
                
        tabBarController.viewControllers = viewControllers
        navigationController.setViewControllers([tabBarController], animated: false)

    }

    func createTabController(_ item: TabBarItemType) -> UINavigationController {
        let navigationController = UINavigationController()
        
        navigationController.setNavigationBarHidden(false, animated: false)
        
        switch item {
        case .home:
            let homeCoordinator = HomeCoordinator(navigationController: navigationController)
            childCoordinators.append(homeCoordinator)
            homeCoordinator.start()
        case .store:
            let storeCoordinator = StoreCoordinator(navigationController: navigationController)
            childCoordinators.append(storeCoordinator)
            storeCoordinator.start()
        case .mypage:
            let mypageCoordinator = MypageCoordinator(navigationController: navigationController)
            childCoordinators.append(mypageCoordinator)
            mypageCoordinator.start()
        }
        
        return navigationController
    }
}
