//
//  UniversityDataRepositoryImpl.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

final class UniversityDataRepositoryImpl: UniversityDataRepository {
    func getUniversityName() async -> Result<[String], NetworkError> {
        return await NetworkManager.shared.request(UniversityDataAPI.getUniversityName)
    }
    
    func postDepartmentName(request: DepartmentRequestDTO) async -> Result<[String], NetworkError> {
        return await NetworkManager.shared.request(UniversityDataAPI.postDepartmentName(request))
    }
}
