//
//  AppCoordinator.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    typealias NavigationControllerType = CustomSignUpNavigationController
    
    var parentCoordinator: (any Coordinator)?
    var navigationController: NavigationControllerType
    var childCoordinators: [any Coordinator] = []
    
    init(navigationController: CustomSignUpNavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLaunchScreen()
    }

    private func showLaunchScreen() {
        let launchScreenVC = LaunchScreenViewController(coordinator: self)
        navigationController.setViewControllers([launchScreenVC], animated: false)
    }
    
    func removeLaunchScreenAndShowLoginFlow() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print("AppCoordinator: removeLaunchScreenAndShowLoginFlow() called")
            // 현재 LaunchScreenViewController를 네비게이션 스택에서 제거
            self.navigationController.viewControllers.removeAll()
            
            let loginCoordinator = LoginCoordinator(navigationController: self.navigationController, parentCoordinator: self)
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

    func showLoginFlow() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController, parentCoordinator: self)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.delegate = self
        loginCoordinator.start()
    }

    func showTabBarFlow() {
        navigationController.viewControllers.removeAll()
        
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            parentCoordinator: self
        )
        
        childCoordinators.append(tabBarCoordinator)
        
        // 애니메이션과 함께 LoginFlow로 전환
        UIView.transition(with: self.navigationController.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            tabBarCoordinator.start()
        }, completion: { _ in
            
        })
    }
}

extension AppCoordinator {
    func moveToLoginFlow() {
        // 1. TabBarCoordinator를 찾아서 정리
        if let tabBarCoordinator = childCoordinators.first(where: { $0 is TabBarCoordinator }) {
            // TabBar의 모든 자식 coordinator 정리
            (tabBarCoordinator as? TabBarCoordinator)?.cleanup()
            
            // AppCoordinator의 childCoordinators에서 TabBarCoordinator 제거
            childCoordinators.removeAll { $0 === tabBarCoordinator }
        }
        
        // 2. 네비게이션 스택 클리어
        navigationController.viewControllers.removeAll()
        
        // 3. 로그인 화면으로 전환
        let loginCoordinator = LoginCoordinator(navigationController: navigationController, parentCoordinator: self)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.delegate = self
        loginCoordinator.start()
    }
}

// MARK: - Delegate Extensions

extension AppCoordinator: LoginCoordinatorDelegate {
    func didLoginFinishFlow(_ coordinator: LoginCoordinator) {
        print("LoginCoordinator 에서 TabBarCoordinator 로 이동")
        childCoordinators.removeAll { $0 === coordinator }
        showTabBarFlow()
    }
}
