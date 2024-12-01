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
    weak var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    
    init(navigationController: UINavigationController,
         parentCoordinator: (any Coordinator)?
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let storeVM = StoreViewModel(
            partnerInfoUseCase: PartnerInfoUseCase(repository: PartnerRepositoryImpl())
        )
        
        let storeVC = StoreViewController(
            storeViewModel: storeVM,
            coordinator: self
        )
        
        navigationController.pushViewController(storeVC, animated: true)
    }
    
    func pushStoreMap(storeData: StoreEntity) {
        
        let storeMapVM = StoreMapViewModel(
            selectStoreData: storeData
        )
        
        let storeMapVC = StoreMapViewController(
            storeMapViewModel: storeMapVM,
            coordinator: self
        )
        
        storeMapVC.modalPresentationStyle = .overFullScreen
        navigationController.present(storeMapVC, animated: true)
    }
}
