//
//  HomeRepositoryImpl.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/12/24.
//

import Foundation

final class HomeRepositoryImpl: HomeRepository {
    func getAssociationLogo() async -> Result<UniversityLogoResponseDTO, NetworkError> {
        return await NetworkManager.shared.request(HomeAPI.getAssociationLogo)
    }
    
    func getUnreadAssociation() async -> Result<UnreadAssociationAuuonceResponseDTO, NetworkError> {
        return await NetworkManager.shared.request(HomeAPI.getUnreadAssociationAnnouce)
    }
    
    func postUnreadAssociationAnnouceCount(associationName: String) async -> Result<UnreadAssocationAnnouceCountResponseDTO, NetworkError> {
        return await NetworkManager.shared.request(HomeAPI.postUnreadAssocationAnnouceCount(UnreadAssocationAnnouceCountRequestDTO(categorie: associationName)))
    }
    
    func postRecentAnnouce(associationName: String) async -> Result<RecentAnnouncementData, NetworkError> {
        return await NetworkManager.shared.request(HomeAPI.postRecentAnnouce(RecentAnnouceRequestDTO(categorie: associationName)))
    }
    
    func getBookmarkAnnouce() async -> Result<BookmarkAnnouceData, NetworkError> {
        return await NetworkManager.shared.request(HomeAPI.getBookmarkAnnouce)
    }
    
    func getMypage() async -> Result<MypageInfoResponseDTO, NetworkError> {
        return await NetworkManager.shared.request(HomeAPI.getMypage)
    }
}
