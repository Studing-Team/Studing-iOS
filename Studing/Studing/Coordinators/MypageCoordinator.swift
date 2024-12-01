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
    weak var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    
    init(navigationController: UINavigationController,
         parentCoordinator: (any Coordinator)?
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let mypageVM = MypageViewModel(mypageUseCase: MypageUseCase(repository: HomeRepositoryImpl()))
        
        let mypageVC = MypageViewController(mypageViewModel: mypageVM, coordinator: self)
        
        navigationController.pushViewController(mypageVC, animated: true)
    }
    
    func pushWithDrawView() {
        let withDrawVM = WithDrawViewModel(withDrawUseCase: WithDrawUseCase(repository: MemberRepositoryImpl()))
        
        let withDrawVC = WithDrawViewController(
            withDrawViewModel: withDrawVM, coordinator: self
        )
        
        withDrawVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(withDrawVC, animated: true)
    }
    
    func removeAuthUser() {
        // parent chain을 통해 AppCoordinator 찾아서 직접 호출
        if let appCoordinator = findParentCoordinator(ofType: AppCoordinator.self) {
            appCoordinator.moveToLoginFlow()
        }
    }
    
    // 특정 타입의 parent coordinator를 찾는 유틸리티 메서드
    private func findParentCoordinator<T: Coordinator>(ofType type: T.Type) -> T? {
        var current = parentCoordinator
        
        while let coordinator = current {
            if let targetCoordinator = coordinator as? T {
                return targetCoordinator
            }
            current = coordinator.parentCoordinator
        }
        
        return nil
    }
}
