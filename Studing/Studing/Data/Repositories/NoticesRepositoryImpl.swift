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
    
    func getDetailAnnounce(noticeId: Int) async throws -> DetailAnnounceEntity {
        
        let response: DetailAnnounceResponseDTO = try await NetworkManager.shared.request(NoticesAPI.getDetailAnnounce(noticeId: noticeId)).get()
        
        return response.toEntity()
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
    
    func postCreateAnnounce(dto: CreateAnnounceRequestDTO) async throws -> EmptyResponse {
        
        let response: EmptyResponse = try await NetworkManager.shared.request(NoticesAPI.postCreateAnnouce(dto)).get()
        
        return response
    }
    
    func editPostAnnounce(noticeId: Int, dto: CreateAnnounceRequestDTO) async -> Result<EmptyResponse, NetworkError> {
        return await NetworkManager.shared.request(NoticesAPI.editPostAnnounce(noticeId: noticeId, dto))
    }
    
    func deletePostAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError> {
        return await NetworkManager.shared.request(NoticesAPI.deletePostAnnounce(noticeId: noticeId))
    }
    
    func postRegistFirstCome(noticeId: Int) async throws -> EmptyResponse {
        
        let response: EmptyResponse = try await NetworkManager.shared.request(NoticesAPI.postRegistFirstCome(noticeId: noticeId)).get()
        
        return response
    }
    
    func getFirstComeRankings(noticeId: Int) async throws -> FirstComeRankingsResponseData {
        
        let response: FirstComeRankingsResponseData = try await NetworkManager.shared.request(NoticesAPI.getFirstComeRankings(noticeId: noticeId)).get()
        
        return response
    }
}
