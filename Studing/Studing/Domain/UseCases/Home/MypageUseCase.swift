//
//  MypageUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/12/24.
//

import Foundation

final class MypageUseCase {
    private let repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func execute() async -> Result<MypageInfoResponseDTO, NetworkError> {
        return await repository.getMypage()
    }
}
