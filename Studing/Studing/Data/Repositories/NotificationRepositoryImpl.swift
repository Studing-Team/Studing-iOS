//
//  NotificationRepositoryImpl.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/14/24.
//

import Foundation

final class NotificationsRepositoryImpl: NotificationsRepository {
    func postNotificationToken(memberId: Int) async -> Result<EmptyResponse, NetworkError> {
        return await NetworkManager.shared.request(NotificationsAPI.postNotificationToken(NotificationTokenRequestDTO(fcmToken: KeychainManager.shared.load(key: .fcmToken) ?? "", memberId: memberId)))
    }
}
