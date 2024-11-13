//
//  SignupUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

final class SignupUseCase {
    private let repository: MemberRepository
    
    init(repository: MemberRepository) {
        self.repository = repository
    }
    
    func execute(request: SignupRequestDTO) async -> Result<EmptyResponse, NetworkError> {
        return await repository.postSignup(request: request)
    }
}
