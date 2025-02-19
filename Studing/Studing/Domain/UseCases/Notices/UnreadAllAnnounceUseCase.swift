//
//  UnreadAllAnnouceUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

protocol PostUnreadAllAnnounceUseCase {
    func execute(noticeId: Int) async throws -> [DetailAnnounceEntity]
}

final class UnreadAllAnnounceUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(associationName: String) async throws -> [DetailAnnounceEntity] {
        return try await repository.postUnreadAllAnnounce(associationName: associationName)
    }
}
