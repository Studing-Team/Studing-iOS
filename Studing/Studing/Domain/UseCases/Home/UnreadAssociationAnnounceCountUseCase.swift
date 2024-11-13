//
//  UnreadAssociationAnnouceCountUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/12/24.
//

import Foundation

final class UnreadAssociationAnnounceCountUseCase {
    private let repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func execute(associationName: String) async -> Result<UnreadAssocationAnnouceCountResponseDTO, NetworkError> {
        return await repository.postUnreadAssociationAnnouceCount(associationName: associationName)
    }
}
