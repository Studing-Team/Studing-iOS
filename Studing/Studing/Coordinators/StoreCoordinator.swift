//
//  StoreCoordinator.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import UIKit

final class StoreCoordinator: Coordinator {
    typealias NavigationControllerType = UINavigationController
    
    var navigationController: UINavigationController
    
    var childCoordinators: [any Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storeVC = StoreViewController()
        navigationController.pushViewController(storeVC, animated: true)
    }
}