//
//  NotificationRepositoryImpl.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/14/24.
//

import Foundation

final class NotificationsRepositoryImpl: NotificationsRepository {
    func postNotificationToken(memberId: Int) async -> Result<EmptyResponse, NetworkError> {
        return await NetworkManager.shared.request(NotificationsAPI.postNotificationToken(NotificationTokenRequestDTO(fcmToken: KeychainManager.shared.load(key: .fcmToken) ?? "", memberId: memberId, platform: "IOS")))
    }
    
    func postAlarmNotice(noticeId: Int, dto: AlarmNoticeRequestDTO) async throws -> EmptyResponse {
        let response: EmptyResponse = try await NetworkManager.shared.request(NotificationsAPI.postAlarmNotice(noticeId: noticeId, dto: dto)).get()
        
        return response
    }
    
    func deleteAlarmNotice(noticeId: Int) async throws -> EmptyResponse {
        let response: EmptyResponse = try await NetworkManager.shared.request(NotificationsAPI.deleteAlarmNotice(noticeId: noticeId)).get()
        
        return response
    }
    
}
