//
//  WithDrawUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/26/24.
//

import Foundation

final class WithDrawUseCase {
    private let repository: MemberRepository
    
    init(repository: MemberRepository) {
        self.repository = repository
    }
    
    func execute() async -> Result<EmptyResponse, NetworkError> {
        return await repository.deleteWithDraw()
    }
}
