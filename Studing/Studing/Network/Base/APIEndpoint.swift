//
//  APIEndpoint.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/10/24.
//

import Alamofire
import Foundation

enum RequestBodyType {
    case json           // raw JSON
    case formData      // multipart/form-data
}

/// 각 API에 따라 공통된 Path 값 (존재하지 않는 경우 빈 String 값)
enum BasePath: String {
    case member = "api/v1/member"
    case universityData = "api/v1/universityData"
    case home = "api/v1/home"
    case notices = "api/v1/notices"
    case partner = "api/v1/partner"
    case notifications = "api/v1/notifications"
    case slack = "api/v1/slack"
    case auth = "api/v1/auth"
    case empty = ""  // 공통 path가 없는 경우
}

protocol APIEndpoint {
    var basePath: BasePath { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var requestBodyType: RequestBodyType { get }
    var headerType: HeaderType { get }
    var parameters: Encodable? { get }
}

extension APIEndpoint {
    var baseURL: URL {
        guard let baseURL = URL(string: Config.baseURL) else {
            fatalError("🍞⛔️ Base URL이 없어요! ⛔️🍞")
        }
        return baseURL
    }

    var requestBodyType: RequestBodyType {
        return .json
    }
    
    /// 각 케이스에 맞는 HTTPHeaders 반환
    var headers: HTTPHeaders {
        var headers: HTTPHeaders = [:]
        
        switch requestBodyType {
        case .json:
            headers["Content-Type"] = "application/json"
        case .formData:
            headers["Content-Type"] = "multipart/form-data"
        }
        
        switch headerType {
        case .accessTokenHeader:
            if let token = KeychainManager.shared.load(key: .accessToken) {
                headers["Authorization"] = "Bearer \(token)"
            }
        case .refreshTokenHeader:
            if let token = KeychainManager.shared.load(key: .refreshToken) {
                headers["Authorization"] = "Bearer \(token)"
            }
        case .defaultHeader:
            break
        }
        
        return headers
    }
}
