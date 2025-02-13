//
//  NoticesAPI.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Alamofire

enum NoticesAPI {
    case getAllAnnounce
    case postAllAssociationAnnounce(AllAssociationAnnounceRequestDTO)
    case postBookmarkAssociationAnnounce(BookmarkAssociationAnnounceListRequestDTO)
    case postCheckAnnouce(noticeId: Int)
    case postUnreadAllAnnouce(UnreadAllAnnounceListRequestDTO)
    case getDetailAnnounce(noticeId: Int)
    case postLikeAnnouce(noticeId: Int)
    case deleteLikeAnnouce(noticeId: Int)
    case postBookmarkAnnouce(noticeId: Int)
    case deleteBookmarkAnnouce(noticeId: Int)
    case postCreateAnnouce(CreateAnnounceRequestDTO)
    case editPostAnnounce(noticeId: Int, CreateAnnounceRequestDTO)
    case deletePostAnnounce(noticeId: Int)
    case postRegistFirstCome(noticeId: Int)
    case getFirstComeRankings(noticeId: Int)
}

extension NoticesAPI: APIEndpoint {
    var basePath: BasePath {
        return .notices
    }
    
    var path: String {
        switch self {
        case .getAllAnnounce:
            return basePath.rawValue + "/all"
        case .postAllAssociationAnnounce:
            return basePath.rawValue + "/all-category"
        case .postBookmarkAssociationAnnounce:
            return basePath.rawValue + "/save-category"
        case .postCheckAnnouce(let noticeId):
            return basePath.rawValue + "/view-check/\(noticeId)"
        case .postUnreadAllAnnouce:
            return basePath.rawValue + "/unread/all"
        case .getDetailAnnounce(let noticeId):
            return basePath.rawValue + "/\(noticeId)"
        case .postLikeAnnouce(let noticeId), .deleteLikeAnnouce(let noticeId):
            return basePath.rawValue + "/like/\(noticeId)"
        case .postBookmarkAnnouce(let noticeId), .deleteBookmarkAnnouce(let noticeId):
            return basePath.rawValue + "/save/\(noticeId)"
        case .postCreateAnnouce:
            return basePath.rawValue + "/create"
        case .editPostAnnounce(let noticeId, _), .deletePostAnnounce(let noticeId):
            return basePath.rawValue + "/\(noticeId)"
        case .postRegistFirstCome(let noticeId):
            return basePath.rawValue + "/first-come/\(noticeId)"
        case .getFirstComeRankings(let noticeId):
            return basePath.rawValue + "/first-come/rankings/\(noticeId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllAnnounce, .getDetailAnnounce, .getFirstComeRankings:
            return .get
        case .postAllAssociationAnnounce, .postBookmarkAssociationAnnounce, .postCheckAnnouce, .postUnreadAllAnnouce, .postLikeAnnouce, .postBookmarkAnnouce, .postCreateAnnouce, .postRegistFirstCome:
            return .post
        case .deleteLikeAnnouce, .deleteBookmarkAnnouce, .deletePostAnnounce:
            return .delete
        case .editPostAnnounce:
            return .put
        }
    }
    
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var requestBodyType: RequestBodyType {
        switch self {
        case .postCreateAnnouce, .editPostAnnounce:
            return .formData
        default:
            return .json
        }
    }
    
    var parameters: Encodable? {
        switch self {
        case .postAllAssociationAnnounce(let dto):
            return dto
        case .postBookmarkAssociationAnnounce(let dto):
            return dto
        case .postUnreadAllAnnouce(let dto):
            return dto
        case .postCreateAnnouce(let dto):
            return dto
        case .editPostAnnounce(_, let dto):
            return dto
        default:
            return nil
        }
    }
}
