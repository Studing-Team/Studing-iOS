//
//  AppCoordinator.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: CustomSignUpNavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: CustomSignUpNavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLaunchScreen()
    }

    private func showLaunchScreen() {
        let launchScreenVC = LaunchScreenViewController()
        navigationController.setViewControllers([launchScreenVC], animated: false)
        
        // LaunchScreen을 일정 시간 동안 표시한 후 로그인 플로우로 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.removeLaunchScreenAndShowLoginFlow()
        }
    }
    
    private func removeLaunchScreenAndShowLoginFlow() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print("AppCoordinator: removeLaunchScreenAndShowLoginFlow() called")
            // 현재 LaunchScreenViewController를 네비게이션 스택에서 제거
            self.navigationController.viewControllers.removeAll()
            
            let loginCoordinator = LoginCoordinator(navigationController: self.navigationController)
            self.childCoordinators.append(loginCoordinator)
            loginCoordinator.delegate = self
            
            // 애니메이션과 함께 LoginFlow로 전환
            UIView.transition(with: self.navigationController.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                loginCoordinator.start()
            }, completion: { _ in
                // 현재 LaunchScreenViewController를 네비게이션 스택에서 제거
                self.navigationController.viewControllers.removeAll { $0 is LaunchScreenViewController }
            })
        }
    }

    private func showLoginFlow() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.delegate = self
        loginCoordinator.start()
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
