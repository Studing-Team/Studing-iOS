//
//  DeleteBookmarkAnnounceUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

final class DeleteBookmarkAnnounceUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(noticeId: Int) async -> Result<EmptyResponse, NetworkError> {
        return await repository.deleteBookmarkAnnounce(noticeId: noticeId)
    }
}
