//
//  HomeRepositoryProtocol.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/12/24.
//

import Foundation

protocol HomeRepository {
    func getAssociationLogo() async -> Result<UniversityLogoResponseDTO, NetworkError>
    func getUnreadAssociation() async -> Result<UnreadAssociationAuuonceResponseDTO, NetworkError>
    func postUnreadAssociationAnnouceCount(associationName: String) async -> Result<UnreadAssocationAnnouceCountResponseDTO, NetworkError>
    func postRecentAnnouce(associationName: String) async -> Result<RecentAnnouncementData, NetworkError>
    func getBookmarkAnnouce() async -> Result<BookmarkAnnouceData, NetworkError>
    func getMypage() async -> Result<MypageInfoResponseDTO, NetworkError>
}
