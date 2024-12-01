//
//  NotificationsAPI.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/14/24.
//

import Alamofire

enum NotificationsAPI {
    case postNotificationToken(NotificationTokenRequestDTO)
}

extension NotificationsAPI: APIEndpoint {
    var basePath: BasePath {
        return .notifications
    }
    
    var path: String {
        switch self {
        case .postNotificationToken:
            return basePath.rawValue + "/token"
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
        case .postNotificationToken(let dto):
            return dto
        }
    }
}
