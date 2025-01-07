//
//  AllAnnounceListResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

struct AllAnnounceListResponseData: Decodable {
    let notices: [AllAnnounceListResponseDTO]
}

struct AllAnnounceListResponseDTO: Decodable {
    let id: Int
    let title: String
    let content: String
    let writerInfo: String
    let likeCount: Int
    let readCount: Int
    let saveCount: Int
    let image: String?
    let createdAt: String
    let saveCheck: Bool
    let likeCheck: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case writerInfo
        case likeCount = "noticeLike"
        case saveCount
        case image
        case createdAt
        case readCount = "viewCount"
        case saveCheck
        case likeCheck
    }
}

extension AllAnnounceListResponseData {
    func toEntities() -> [AllAnnounceEntity] {
        return notices.map { $0.toEntity() }
    }
}

extension AllAnnounceListResponseDTO {
    func toEntity() -> AllAnnounceEntity {
        
        let (parsedWriterInfo, associationType) = parseWriterInfoAndType(writerInfo)
        
        return AllAnnounceEntity(
            announceId: id,
            associationType: associationType,
            title: title,
            contents: content,
            writerInfo: parsedWriterInfo,
            days: createdAt.formatDate(from: createdAt),
            favoriteCount: likeCount,
            bookmarkCount: saveCount,
            watchCount: readCount,
            isFavorite: likeCheck,
            isBookmark: saveCheck,
            imageUrl: image
        )
    }
    
    private func parseWriterInfoAndType(_ text: String) -> (writerInfo: String, type: AssociationType) {
        // "총학생회[총학생회]" 형태의 문자열을 처리
        if let range = text.range(of: "\\[.*\\]", options: .regularExpression) {
            let writerInfo = String(text[..<range.lowerBound]).trimmingCharacters(in: .whitespaces)
            let typeString = text[range].trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
            return (writerInfo, convertToAssociationType(typeString))
        }
        
        // 대괄호가 없는 경우 전체를 writerInfo로 처리
        return (text, .generalStudents)
    }
    
    private func convertToAssociationType(_ type: String) -> AssociationType {
        switch type {
        case "총학생회":
            return .generalStudents
        case "단과대":
            return .college
        case "학과":
            return .major
        default:
            return .generalStudents
        }
    }
}
