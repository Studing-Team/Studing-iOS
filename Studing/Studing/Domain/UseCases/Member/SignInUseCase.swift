//
//  SignInUsecase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

final class SignInUseCase {
    private let repository: MemberRepository
    
    init(repository: MemberRepository) {
        self.repository = repository
    }
    
    func execute(loginRequest: LoginRequestDTO) async -> Result<LoginResponseDTO, NetworkError> {
        return await repository.postSignin(request: loginRequest)
    }
}
