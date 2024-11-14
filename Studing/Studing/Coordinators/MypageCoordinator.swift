//
//  MypageCoordinator.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import UIKit

final class MypageCoordinator: Coordinator {
    typealias NavigationControllerType = UINavigationController
    
    var navigationController: UINavigationController
    
    var childCoordinators: [any Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mypageVM = MypageViewModel(mypageUseCase: MypageUseCase(repository: HomeRepositoryImpl()))
        
        let mypageVC = MypageViewController(mypageViewModel: mypageVM, coordinator: self)
        navigationController.pushViewController(mypageVC, animated: true)
    }
}
