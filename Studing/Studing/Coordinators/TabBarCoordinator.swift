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
    
    weak var parentCoordinator: (any Coordinator)?
    var tabBarController: UITabBarController
    var navigationController: NavigationControllerType
    var childCoordinators: [any Coordinator] = []
    
    init(navigationController: UINavigationController, parentCoordinator: (any Coordinator)?) {
        self.navigationController = navigationController
        self.tabBarController = CustomTabBarViewController()
        self.parentCoordinator = parentCoordinator
    }
  
    func start() {
        print("TabBarCoordinator 시작")
        let pages: [TabBarItemType] = [.home, .store, .mypage]
        
        let viewControllers = pages.map { createTabController($0) }
                
        tabBarController.viewControllers = viewControllers
        navigationController.setViewControllers([tabBarController], animated: false)

    }

    func createTabController(_ item: TabBarItemType) -> UINavigationController {
        var navigationController = UINavigationController()
        
        navigationController.setNavigationBarHidden(false, animated: false)
        
        switch item {
        case .home:
            navigationController = CustomAnnouceNavigationController()
            let homeCoordinator = HomeCoordinator(navigationController: navigationController as! CustomAnnouceNavigationController, parentCoordinator: self)
            childCoordinators.append(homeCoordinator)
            homeCoordinator.start()
        case .store:
            navigationController = UINavigationController()
            let storeCoordinator = StoreCoordinator(navigationController: navigationController, parentCoordinator: self)
            childCoordinators.append(storeCoordinator)
            storeCoordinator.start()
        case .mypage:
            navigationController = UINavigationController()
            let mypageCoordinator = MypageCoordinator(navigationController: navigationController, parentCoordinator: self)
            childCoordinators.append(mypageCoordinator)
            mypageCoordinator.start()
        }
        
        return navigationController
    }
    
    func cleanup() {
        // 모든 자식 coordinator 제거
        childCoordinators.removeAll()
    }
}
