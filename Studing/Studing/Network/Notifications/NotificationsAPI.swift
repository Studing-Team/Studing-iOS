//
//  NotificationsAPI.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/14/24.
//

import Alamofire

enum NotificationsAPI {
    case postNotificationToken(NotificationTokenRequestDTO)
    case postAlarmNotice(noticeId: Int, dto: AlarmNoticeRequestDTO)
    case deleteAlarmNotice(noticeId: Int)
}

extension NotificationsAPI: APIEndpoint {
    var basePath: BasePath {
        return .notifications
    }
    
    var path: String {
        switch self {
        case .postNotificationToken:
            return basePath.rawValue + "/token"
        case .postAlarmNotice(let noticeId, _), .deleteAlarmNotice(let noticeId):
            return basePath.rawValue + "/alarm/notice/\(noticeId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postNotificationToken, .postAlarmNotice:
            return .post
            
        case .deleteAlarmNotice:
            return .delete
        }
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
        case .postAlarmNotice(_, let dto):
            return dto
        default:
            return nil
        }
    }
}
