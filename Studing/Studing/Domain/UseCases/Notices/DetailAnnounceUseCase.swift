//
//  DetailAnnounceUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

protocol GetDetailAnnounceUseCase {
    func execute(noticeId: Int) async throws -> DetailAnnounceEntity
}

final class DetailAnnounceUseCase: GetDetailAnnounceUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(noticeId: Int) async throws -> DetailAnnounceEntity {
        return try await repository.getDetailAnnounce(noticeId: noticeId)
    }
}
