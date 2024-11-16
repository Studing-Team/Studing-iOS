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
        let storeVM = StoreViewModel(partnerInfoUseCase: PartnerInfoUseCase(repository: PartnerRepositoryImpl()))
        
        let storeVC = StoreViewController(storeViewModel: storeVM)
        navigationController.pushViewController(storeVC, animated: true)
    }
}
