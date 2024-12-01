//
//  NoticesRepositoryImpl.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

final class NoticesRepositoryImpl: NoticesRepository {
    func getAllAnnounce() async -> Result<AllAnnounceListResponseData, NetworkError> {
        return await NetworkManager.shared.request(NoticesAPI.getAllAnnounce)
    }
    
    func postAllAssociationAnnounce(associationName: String) async -> Result<AllAssociationAnnounceListResponseData, NetworkError> {
        return await NetworkManager.shared.request(NoticesAPI.postAllAssociationAnnounce(AllAssociationAnnounceRequestDTO(categorie: associationName)))
    }
    
    func postBookmarkAssociationAnnounce(associationName: String) async -> Result<BookmarkAssociationAnnounceListResponseData, NetworkError> {
        return await NetworkManager.shared.request(NoticesAPI.postBookmarkAssociationAnnounce(BookmarkAssociationAnnounceListRequestDTO(categorie: associationName)))
    }
    
    func postCheckAnnounce(noticeId: Int) async -> Result<SpecificStatusResponseDTO, NetworkError> {
        return await NetworkManager.shared.request(NoticesAPI.postCheckAnnouce(noticeId: noticeId))
    }
    
    func postUnreadAllAnnounce(associationName: String) async -> Result<UnreadAllAnnounceListResponseData, NetworkError> {
        return await NetworkManager.shared.request(NoticesAPI.postUnreadAllAnnouce(UnreadAllAnnounceListRequestDTO(categorie: associationName)))
    }
    
    func getDetailAnnounce(noticeId: Int) async -> Result<DetailAnnounceResponseDTO, NetworkError> {
        return await NetworkManager.shared.request(NoticesAPI.getDetailAnnounce(noticeId: noticeId))
    }
    
    func postLikeAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError> {
        return await NetworkManager.shared.request(NoticesAPI.postLikeAnnouce(noticeId: noticeId))
    }
    
    func deleteLikeAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError> {
        return await NetworkManager.shared.request(NoticesAPI.deleteLikeAnnouce(noticeId: noticeId))
    }
    
    func postBookmarkAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError> {
        return await NetworkManager.shared.request(NoticesAPI.postBookmarkAnnouce(noticeId: noticeId))
    }
    
    func deleteBookmarkAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError> {
        return await NetworkManager.shared.request(NoticesAPI.deleteBookmarkAnnouce(noticeId: noticeId))
    }
    
    func postCreateAnnounce(dto: CreateAnnounceRequestDTO) async -> Result<EmptyResponse, NetworkError> {
        return await NetworkManager.shared.request(NoticesAPI.postCreateAnnouce(dto))
    }
    
    
}
