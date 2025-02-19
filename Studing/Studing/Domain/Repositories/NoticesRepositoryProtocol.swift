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
    func postCheckAnnounce(noticeId: Int) async -> Result<SpecificStatusResponseDTO, NetworkError>
    func postUnreadAllAnnounce(associationName: String) async throws -> [DetailAnnounceEntity]
    func getDetailAnnounce(noticeId: Int) async throws -> DetailAnnounceEntity
    func postLikeAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError>
    func deleteLikeAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError>
    func postBookmarkAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError>
    func deleteBookmarkAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError>
    func postCreateAnnounce(dto: CreateAnnounceRequestDTO) async throws -> EmptyResponse
    func editPostAnnounce(noticeId: Int, dto: CreateAnnounceRequestDTO) async -> Result<EmptyResponse, NetworkError>
    func deletePostAnnounce(noticeId: Int) async -> Result<EmptyResponse, NetworkError>
    func postRegistFirstCome(noticeId: Int) async throws -> EmptyResponse
    func getFirstComeRankings(noticeId: Int) async throws -> FirstComeRankingsResponseData
}
