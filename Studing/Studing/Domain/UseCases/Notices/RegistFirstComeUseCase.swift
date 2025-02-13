//
//  RegistFirstComeUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/4/25.
//

import Foundation

protocol postRegistFirstComeUseCase {
    func execute(noticeId: Int) async throws -> EmptyResponse
}

final class RegistFirstComeUseCase: postRegistFirstComeUseCase {
    private let repository: NoticesRepository
    
    init(repository: NoticesRepository) {
        self.repository = repository
    }
    
    func execute(noticeId: Int) async throws -> EmptyResponse {
        return try await repository.postRegistFirstCome(noticeId: noticeId)
    }
}
