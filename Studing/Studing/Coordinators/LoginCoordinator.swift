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
    var navigationController: CustomSignUpNavigationController
    var childCoordinators: [any Coordinator] = []
    var delegate: LoginCoordinatorDelegate?
    
    init(navigationController: CustomSignUpNavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewModel = LoginViewModel(
            signInUseCase: SignInUseCase(repository: MemberRepositoryImpl())
        )
        
        let loginVC = LoginViewController(viewModel: loginViewModel, coordinator: self)
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    func showSignUp() {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        childCoordinators.append(signUpCoordinator)
        signUpCoordinator.delegate = self
        signUpCoordinator.start()
    }
    
    func login() {
        delegate?.didLoginFinishFlow(self)
    }
}

extension LoginCoordinator: SignUpCoordinatorDelegate {
    func didSignUpFinishFlow(_ coordinator: SignUpCoordinator) {
        childCoordinators.removeAll { $0 === coordinator }
        delegate?.didLoginFinishFlow(self)  // LoginCoordinator의 delegate 메서드를 호출
    }
}
