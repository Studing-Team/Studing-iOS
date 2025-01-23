//
//  BookmarkAnnouceResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

struct BookmarkAnnouceData: Decodable {
   let notices: [BookmarkAnnouceResponseDTO]
}

struct BookmarkAnnouceResponseDTO: Decodable {
    let id: Int
    let affiliation: String
    let title: String
    let content: String
    let createdAt: String
    let saveCheck: Bool
}

extension BookmarkAnnouceResponseDTO {
    func toEntity() -> BookmarkAnnounceEntity {
        let (parsedWriterInfo, associationType) = parseWriterInfoAndType(affiliation)
        
        return BookmarkAnnounceEntity(
            bookmarkId: self.id,
            association: parsedWriterInfo,
            associationType: associationType,
            title: self.title,
            contents: self.content,
            days: self.createdAt.formatDate(from: self.createdAt),
            saveCheck: self.saveCheck
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
