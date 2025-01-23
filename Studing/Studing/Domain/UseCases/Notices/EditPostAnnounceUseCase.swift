//
//  EditPostAnnounceUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/14/25.
//

import Foundation

final class EditPostAnnounceUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(noticeId: Int, dto: CreateAnnounceRequestDTO) async -> Result<EmptyResponse, NetworkError> {
        return await repository.editPostAnnounce(noticeId: noticeId, dto: dto)
    }
}
