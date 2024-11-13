//
//  UnreadAllAnnouceUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

final class UnreadAllAnnounceUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(associationName: String) async -> Result<UnreadAllAnnounceListResponseData,NetworkError> {
        return await repository.postUnreadAllAnnounce(associationName: associationName)
    }
}
