//
//  LoginCoordinator.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import UIKit

protocol LoginCoordinatorDelegate {
    func didLoginFinishFlow(_ coordinator: LoginCoordinator)
}

final class LoginCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var delegate: LoginCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewModel = LoginViewModel()
        let loginVC = LoginViewController(viewModel: loginViewModel, coordinator: self)
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    func showSignUp() {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        childCoordinators.append(signUpCoordinator)
//        signUpCoordinator.parentCoordinator = self
        signUpCoordinator.start()
    }
    
    func login() {
        delegate?.didLoginFinishFlow(self)
    }
}