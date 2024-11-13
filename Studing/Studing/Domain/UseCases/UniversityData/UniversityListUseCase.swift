//
//  UniversityListUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

final class UniversityListUseCase {
    
    private let repository: UniversityDataRepository
    
    init(repository: UniversityDataRepository) {
        self.repository = repository
    }
    
    func execute() async -> Result<[String], NetworkError> {
        return await repository.getUniversityName()
    }
}
