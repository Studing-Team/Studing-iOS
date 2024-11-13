//
//  DetailAnnounceUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

final class DetailAnnounceUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(noticeId: Int) async -> Result<DetailAnnounceResponseDTO,NetworkError> {
        return await repository.getDetailAnnounce(noticeId: noticeId)
    }
}
