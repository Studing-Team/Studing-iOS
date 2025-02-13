//
//  AlarmNoticeUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/5/25.
//

import Foundation

protocol PostAlarmNoticeUseCase: AnyObject {
    func execute(noticeId: Int, dto: AlarmNoticeRequestDTO) async throws -> EmptyResponse
}

final class AlarmNoticeUseCase: PostAlarmNoticeUseCase {
    private let repository: NotificationsRepository
    
    init(repository: NotificationsRepository) {
        self.repository = repository
    }
    
    func execute(noticeId: Int, dto: AlarmNoticeRequestDTO) async throws -> EmptyResponse {
        return try await repository.postAlarmNotice(noticeId: noticeId, dto: dto)
    }
}
