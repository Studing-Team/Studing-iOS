//
//  AllAssociationAnnounceListUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

final class AllAssociationAnnounceListUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(associationName: String) async -> Result<AllAssociationAnnounceListResponseData,NetworkError> {
        return await repository.postAllAssociationAnnounce(associationName: associationName)
    }
}
