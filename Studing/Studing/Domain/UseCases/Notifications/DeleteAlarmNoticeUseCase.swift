//
//  DeleteAlarmNoticeUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/5/25.
//

import Foundation

protocol DeleteAlarmNoticeUseCase: AnyObject {
    func execute(noticeId: Int) async throws -> EmptyResponse
}

final class RemoveAlarmNoticeUseCase: DeleteAlarmNoticeUseCase {
    private let repository: NotificationsRepository
    
    init(repository: NotificationsRepository) {
        self.repository = repository
    }
    
    func execute(noticeId: Int) async throws -> EmptyResponse {
        return try await repository.deleteAlarmNotice(noticeId: noticeId)
    }
}
