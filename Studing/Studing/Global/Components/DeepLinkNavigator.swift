//
//  DeepLinkNavigator.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/2/25.
//

import Foundation

enum DeepLinkDestination {
    case notice(id: Int)
    case verification
    
    init?(pushPayload: [AnyHashable: Any]) {
        guard let type = pushPayload["type"] as? String else { return nil }
        
        switch type.uppercased() {
        case "NOTICE":
            if let noticeId = pushPayload["noticeId"] as? String,
               let id = Int(noticeId) {
                self = .notice(id: id)
            } else {
                return nil
            }
        case "VERIFICATION":
            self = .verification
        default:
            return nil
        }
    }
    
    var navigationPath: [CoordinatorType] {
        switch self {
        case .notice:
            return [.tabbar, .home]
        case .verification:
            return [.tabbar, .home]
        }
    }
}

enum CoordinatorType {
    case tabbar
    case home
    case mypage
    case store
}

protocol DeepLinkManagerDelegate: AnyObject {
    func receiveDeepLink(type: DeepLinkDestination)
}

protocol DeepLinkCoordinator: AnyObject {
    func navigate(to destination: DeepLinkDestination, data: Any?) -> Bool
    func coordinatorType() -> CoordinatorType
}


final class DeepLinkNavigator {
    
    static let shared = DeepLinkNavigator()
    weak var delegate: DeepLinkManagerDelegate?
    
    private var pendingDeepLink: DeepLinkDestination?
    
    // 현재 활성화된 coordinator chain을 저장
    private var activeCoordinators: [DeepLinkCoordinator] = []
    
    private init() {}
    
    func setActiveCoordinator(_ coordinator: DeepLinkCoordinator) {
        // coordinator chain 업데이트
        activeCoordinators.append(coordinator)
        
        // 대기 중인 딥링크가 있고, 필요한 모든 coordinator가 준비되었다면 처리
        if let pendingLink = pendingDeepLink {
            handleNavigationIfPossible(to: pendingLink)
        }
    }
    
    func removeCoordinator(_ coordinator: DeepLinkCoordinator) {
        activeCoordinators.removeAll { $0 === coordinator }
    }
    
    func handle(destination: DeepLinkDestination) {
        handleNavigationIfPossible(to: destination)
    }
    
    
    private func handleNavigationIfPossible(to destination: DeepLinkDestination) {
        let requiredPath = destination.navigationPath
        
        // 필요한 모든 coordinator가 준비되었는지 확인
        let hasRequiredCoordinators = requiredPath.allSatisfy { pathType in
            activeCoordinators.contains { $0.coordinatorType() == pathType }
        }
        
        if !hasRequiredCoordinators {
            // 필요한 coordinator가 아직 준비되지 않았으면 저장
            pendingDeepLink = destination
            return
        }
        
        // 각 coordinator 순서대로 navigate 호출
        for pathType in requiredPath {
            guard let coordinator = activeCoordinators.first(where: { $0.coordinatorType() == pathType }) else { continue }
            
            let success = coordinator.navigate(to: destination, data: nil)
            if !success {
                // 실패 시 처리
                print("Navigation failed at coordinator: \(pathType)")
                break
            }
        }
        
        pendingDeepLink = nil
    }
}
