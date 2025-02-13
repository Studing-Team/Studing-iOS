//
//  NotificationsRepositoryProtocol.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/14/24.
//

import Foundation

protocol NotificationsRepository {
    func postNotificationToken(memberId: Int) async -> Result<EmptyResponse, NetworkError>
    func postAlarmNotice(noticeId: Int, dto: AlarmNoticeRequestDTO) async throws -> EmptyResponse
    func deleteAlarmNotice(noticeId: Int) async throws -> EmptyResponse
}
