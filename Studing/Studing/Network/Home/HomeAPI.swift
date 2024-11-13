//
//  HomeAPI.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Alamofire

enum HomeAPI {
    case getAssociationLogo
    case getUnreadAssociationAnnouce
    case postUnreadAssocationAnnouceCount(UnreadAssocationAnnouceCountRequestDTO)
    case postRecentAnnouce(RecentAnnouceRequestDTO)
    case getBookmarkAnnouce
    case getMypage
}

extension HomeAPI: APIEndpoint {
    var basePath: BasePath {
        return .home
    }
    
    var path: String {
        switch self {
        case .getAssociationLogo:
            return basePath.rawValue + "/logo"
        case .getUnreadAssociationAnnouce:
            return basePath.rawValue + "/unread-categories"
        case .postUnreadAssocationAnnouceCount:
            return basePath.rawValue + "/unread-notice-count"
        case .postRecentAnnouce:
            return basePath.rawValue + "/recent-notices"
        case .getBookmarkAnnouce:
            return basePath.rawValue + "/save"
        case .getMypage:
            return basePath.rawValue + "/mypage"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAssociationLogo, .getUnreadAssociationAnnouce, .getBookmarkAnnouce, .getMypage:
            return .get
        case .postUnreadAssocationAnnouceCount, .postRecentAnnouce:
            return .post
        }
    }
    
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var parameters: Encodable? {
        switch self {
        case .postUnreadAssocationAnnouceCount(let params):
            return params
        case .postRecentAnnouce(let params):
            return params
        default:
            return nil
        }
    }
}
