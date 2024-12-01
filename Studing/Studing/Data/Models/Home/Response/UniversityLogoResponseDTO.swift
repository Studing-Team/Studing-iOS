//
//  UniversityLogoResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

struct UniversityLogoResponseDTO: Decodable {
    let universityLogoImage: String
    let universityName: String
    let collegeDepartmentLogoImage: String
    let collegeDepartmentName: String
    let departmentLogoImage: String?  // null이 올 수 있으므로 옵셔널
    let departmentName: String
    let isRegisteredDepartment: Bool
}
