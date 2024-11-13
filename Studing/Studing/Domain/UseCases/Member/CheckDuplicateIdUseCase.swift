//
//  CheckDuplicateIdUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

final class CheckDuplicateIdUseCase {
    private let repository: MemberRepository
    
    init(repository: MemberRepository) {
        self.repository = repository
    }
    
    func execute(userId: String) async -> Result<EmptyResponse, NetworkError> {
        return await repository.postCheckDuplicatedId(userId: userId)
    }
}
