//
//  UnreadAssociationUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/12/24.
//

import Foundation

final class UnreadAssociationUseCase {
    
    private let repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func execute() async -> Result<UnreadAssociationAuuonceResponseDTO, NetworkError> {
        return await repository.getUnreadAssociation()
    }
}
