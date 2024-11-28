//
//  SceneDelegate.swift
//  Studing
//
//  Created by ParkJunHyuk on 8/31/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = CustomSignUpNavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController)
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.overrideUserInterfaceStyle = .light
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        appCoordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        Task {
            await checkUserAuth()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate {
    private func checkUserAuth() async {
        let mypageUseCase = MypageUseCase(repository: HomeRepositoryImpl())
        
        switch await mypageUseCase.execute() {
        case .success(let response):
            let entity = response.toEntity()
            
            KeychainManager.shared.saveData(key: .userAuthState, value: entity.role.rawValue)
            
            NotificationCenter.default.post(
                            name: .userAuthDidUpdate,
                            object: nil,
                            userInfo: ["userAuth": entity.role] // 필요한 데이터를 dictionary로 전달
                        )
            
        case .failure:
            break
        }
    }
}
