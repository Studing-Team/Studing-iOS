//
//  AssociationLogoUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/12/24.
//

import Foundation

final class AssociationLogoUseCase {
    
    private let repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func execute() async -> Result<UniversityLogoResponseDTO, NetworkError> {
        return await repository.getAssociationLogo()
    }
}
