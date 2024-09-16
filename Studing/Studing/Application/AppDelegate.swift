//
//  AppDelegate.swift
//  Studing
//
//  Created by ParkJunHyuk on 8/31/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 네비게이션 바의 외관을 설정합니다.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        // 네비게이션 바 제목과 큰 제목의 색상
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        // 네비게이션 바 버튼 색상 설정
        appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]

        // 전체 네비게이션 바에 적용
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

