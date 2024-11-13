//
//  DepartmentListUseCase.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

final class DepartmentListUseCase {
    
    private let repository: UniversityDataRepository
    
    init(repository: UniversityDataRepository) {
        self.repository = repository
    }
    
    func execute(request: DepartmentRequestDTO) async -> Result<[String], NetworkError> {
        return await repository.postDepartmentName(request: request)
    }
}
