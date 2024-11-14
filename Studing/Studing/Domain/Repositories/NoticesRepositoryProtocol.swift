//
//  NoticesRepositoryProtocol.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

protocol NoticesRepository {
    func getAllAnnounce() async -> Result<AllAnnounceListResponseData,NetworkError>
    func postAllAssociationAnnounce(associationName: String) async -> Result<AllAssociationAnnounceListResponseData, NetworkError>
    func postBookmarkAssociationAnnounce(associationName: String) async -> Result<BookmarkAssociationAnnounceListResponseData, NetworkError>
    func postCheckAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError>
    func postUnreadAllAnnounce(associationName: String) async -> Result<UnreadAllAnnounceListResponseData, NetworkError>
    func getDetailAnnounce(noticeId: Int) async -> Result<DetailAnnounceResponseDTO, NetworkError>
    func postLikeAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError>
    func deleteLikeAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError>
    func postBookmarkAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError>
    func deleteBookmarkAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError>
    func postCreateAnnounce(dto: CreateAnnounceRequestDTO) async -> Result<EmptyResponse, NetworkError>
}
