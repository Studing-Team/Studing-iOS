//
//  ReSubmitUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/27/24.
//

import Foundation

final class ReSubmitUseCase {
    private let repository: MemberRepository
    
    init(repository: MemberRepository) {
        self.repository = repository
    }
    
    func execute(dto: ReSubmitRequestDTO) async -> Result<EmptyResponse, NetworkError> {
        return await repository.postReSubmit(request: dto)
    }
}
