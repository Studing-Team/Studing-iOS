//
//  UniversityDataAPI.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Alamofire
//
enum UniversityDataAPI {
    case getUniversityName
    case postDepartmentName(DepartmentRequestDTO)
}

extension UniversityDataAPI: APIEndpoint {
    var basePath: BasePath {
        return .universityData
    }
    
    var path: String {
        switch self {
        case .getUniversityName:
            return basePath.rawValue + "/university"
        case .postDepartmentName:
            return basePath.rawValue + "/department"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUniversityName:
            return .get
        case .postDepartmentName:
            return .post
        }
    }
    
    var headerType: HeaderType {
        return .defaultHeader
    }
    
    var parameters: Encodable? {
        switch self {
        case .postDepartmentName(let dto):
            return dto
        default:
            return nil
        }
    }
}
