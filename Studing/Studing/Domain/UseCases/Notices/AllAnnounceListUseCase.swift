//
//  AllAnnounceListUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

final class AllAnnounceListUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute() async -> Result<AllAnnounceListResponseData,NetworkError> {
        return await repository.getAllAnnounce()
    }
}
