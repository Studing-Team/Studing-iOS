//
//  CheckAnnouceUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

final class CheckAnnounceUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(noticeId: Int) async -> Result<SpecificStatusResponseDTO,NetworkError> {
        return await repository.postCheckAnnounce(noticeId: noticeId)
    }
}
