//
//  CreateAnnounceUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

protocol PostCreateAnnounceUseCase {
    func execute(dto: CreateAnnounceRequestDTO) async throws -> EmptyResponse
}

final class CreateAnnounceUseCase: PostCreateAnnounceUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(dto: CreateAnnounceRequestDTO) async throws -> EmptyResponse {
        return try await repository.postCreateAnnounce(dto: dto)
    }
}
