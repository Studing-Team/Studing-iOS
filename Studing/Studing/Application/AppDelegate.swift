//
//  AppDelegate.swift
//  Studing
//
//  Created by ParkJunHyuk on 8/31/24.
//

import UIKit
import FirebaseCore
import FirebaseMessaging

import UserNotifications
//import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - FireBase 설정
        
        FirebaseApp.configure()
        
        // 앱 실행 시 사용자에게 알림 허용 권한
        UNUserNotificationCenter.current().delegate = self
        
//        requestNotificationPermission()
        
        // UNUserNotificationCenterDelegate 를 구현한 메서드 실행
        application.registerForRemoteNotifications()
        
        // FCM 델리게이트 설정 추가
        Messaging.messaging().delegate = self
        
        // MARK: - NavigationBar 설정
        
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

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    
    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

        print("토큰을 받았다")
        // Store this token to firebase and retrieve when to send message to someone...
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        
        // Store token in Firestore For Sending Notifications From Server in Future...
        
        print(dataDict)
        
        if let fcmToken {
            let _ = KeychainManager.shared.save(key: .fcmToken, value: fcmToken)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Foreground 상태에서 알림 받았을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo

        print(userInfo)
        
        completionHandler([[.banner, .badge, .sound]])
    }
    
    // 푸시메세지를 받았을 떄
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
        
        completionHandler()
    }
    
//    func requestNotificationPermission() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if let error = error {
//                print("Error requesting notification permission: \(error)")
//                return
//            }
//            if granted {
//                print("Notification permission granted.")
//            } else {
//                print("Notification permission denied.")
//            }
//        }
//    }
}

// MARK: - APNs 토큰 관련 메서드 추가

extension AppDelegate {
    // APNs 토큰 등록 성공
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        print("Succuess to register for remote notifications")

    }
    
    // APNs 토큰 등록 실패
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
}
