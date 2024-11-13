//
//  UniversityDataRepository.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

protocol UniversityDataRepository {
    func getUniversityName() async -> Result<[String], NetworkError>
    func postDepartmentName(request: DepartmentRequestDTO) async -> Result<[String], NetworkError>
}
