//
//  AppCoordinator.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLoginFlow()
    }

    private func showLoginFlow() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.delegate = self
        loginCoordinator.start()
    }
    
    private func showSignUpFlow() {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        childCoordinators.append(signUpCoordinator)
        signUpCoordinator.start()
    }

    private func showMainFlow() {
        // TODO: - MainView 로의 전환
    }
}

// MARK: - Delegate Extensions

extension AppCoordinator: LoginCoordinatorDelegate {
    func didLoginFinishFlow(_ coordinator: LoginCoordinator) {
        childCoordinators.removeAll { $0 === coordinator }
        showMainFlow()
    }
}
