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
    case deleteWithDraw
    case postReSubmit(ReSubmitRequestDTO)
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
        case .deleteWithDraw:
            return basePath.rawValue + "/withdraw"
        case .postReSubmit:
            return basePath.rawValue + "/resubmit"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postSignin, .postSignup, .postCheckId, .postReSubmit:
            return .post
        case .deleteWithDraw:
            return .delete
        }
    }
    
    var headerType: HeaderType {
        switch self {
        case .postReSubmit, .deleteWithDraw:
            return .accessTokenHeader
        default:
            return .defaultHeader
        }
    }
    
    var requestBodyType: RequestBodyType {
        switch self {
        case .postSignin, .postSignup, .postReSubmit:
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
        case .postReSubmit(let dto):
            return dto
        default:
            return nil
        }
    }
}
