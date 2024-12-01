//
//  CreateAnnounceUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

final class CreateAnnounceUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(dto: CreateAnnounceRequestDTO) async -> Result<EmptyResponse, NetworkError> {
        return await repository.postCreateAnnounce(dto: dto)
    }
}
