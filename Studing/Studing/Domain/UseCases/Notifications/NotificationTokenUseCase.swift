//
//  NotificationTokenUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/14/24.
//

import Foundation

final class NotificationTokenUseCase {
    private let repository: NotificationsRepository
    
    init(repository: NotificationsRepository) {
        self.repository = repository
    }
    
    func execute() async -> Result<EmptyResponse,NetworkError> {
        return await repository.postNotificationToken()
    }
}
