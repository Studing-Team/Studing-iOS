//
//  RecentAnnouceUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/12/24.
//

import Foundation

final class RecentAnnounceUseCase {
    private let repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func execute(associationName: String) async -> Result<RecentAnnouncementData, NetworkError> {
        return await repository.postRecentAnnouce(associationName: associationName)
    }
}
