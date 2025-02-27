//
//  EditPostAnnounceUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/14/25.
//

import Foundation

protocol PutEditPostAnnounceUseCase {
    func execute(noticeId: Int, dto: CreateAnnounceRequestDTO) async throws -> EmptyResponse
}

final class EditPostAnnounceUseCase: PutEditPostAnnounceUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(noticeId: Int, dto: CreateAnnounceRequestDTO) async throws -> EmptyResponse {
        return try await repository.editPostAnnounce(noticeId: noticeId, dto: dto)
    }
}
