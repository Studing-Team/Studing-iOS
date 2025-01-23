//
//  DeletePostAnnounceUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/14/25.
//

import Foundation

final class DeletePostAnnounceUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(noticeId: Int) async -> Result<EmptyResponse, NetworkError> {
        return await repository.deletePostAnnounce(noticeId: noticeId)
    }
}
