//
//  PartnerAPI.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/15/24.
//

import Alamofire

enum PartnerAPI {
    case postPartnerInfo(PartnerInfoRequestDTO)
}

extension PartnerAPI: APIEndpoint {
    var basePath: BasePath {
        return .partner
    }
    
    var path: String {
        switch self {
        case .postPartnerInfo:
            return basePath.rawValue
        }
    }
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var requestBodyType: RequestBodyType {
        return .json
    }
    
    var parameters: (any Encodable)? {
        switch self {
        case .postPartnerInfo(let dto):
            return dto
        }
    }
}
