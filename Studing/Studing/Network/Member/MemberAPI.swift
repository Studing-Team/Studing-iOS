//
//  MemberAPI.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/10/24.
//

import Alamofire

struct EmptyResponse: Decodable {}

enum MemberAPI {
    case postSignin(LoginRequestDTO)
    case postSignup(SignupRequestDTO)
    case postCheckId(DuplicationIdRequestDTO)
}

extension MemberAPI: APIEndpoint {
    var basePath: BasePath {
        return .member
    }
    
    var path: String {
        switch self {
        case .postSignin:
            return basePath.rawValue + "/signin"
        case .postSignup:
            return basePath.rawValue + "/signup"
        case .postCheckId:
            return basePath.rawValue + "/checkid"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var headerType: HeaderType {
        return .defaultHeader
    }
    
    var requestBodyType: RequestBodyType {
        switch self {
        case .postSignin, .postSignup:
            return .formData
        default:
            return .json
        }
    }
    
    var parameters: Encodable? {
        switch self {
        case .postSignin(let dto):
            return dto
        case .postSignup(let dto):
            return dto
        case .postCheckId(let dto):
            return dto
        }
    }
}
