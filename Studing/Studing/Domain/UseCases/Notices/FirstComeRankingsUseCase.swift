//
//  FirstComeRankingsUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/24/25.
//

import Foundation

protocol GetFirstComeRankingsUseCase {
    func execute(noticeId: Int) async throws -> FirstComeRankingsResponseData
}

final class FirstComeRankingsUseCase: GetFirstComeRankingsUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(noticeId: Int) async throws -> FirstComeRankingsResponseData {
        return try await repository.getFirstComeRankings(noticeId: noticeId)
    }
}
