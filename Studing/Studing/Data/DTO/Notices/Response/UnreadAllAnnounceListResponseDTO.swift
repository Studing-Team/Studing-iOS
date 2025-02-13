//
//  UnreadAllAnnounceListResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

struct UnreadAllAnnounceListResponseData: Decodable {
    let notices: [UnreadAllAnnounceListResponseDTO]
}

struct UnreadAllAnnounceListResponseDTO: Decodable {
    let id: Int
    let title: String
    let content: String
    let likeCount: Int
    let saveCount: Int
    let readCount: Int
    let createdAt: String
    let affilitionName: String
    let logoImage: String
    let tag: String
    let images: [String]?
    let saveCheck: Bool
    let likeCheck: Bool
    let isAuthor: Bool
    let startTime: String?
    let endTime: String?
    let isFirstComeNotice: Bool
    let isFirstComeApplied: Bool
    let alarmTime: String?
}

extension UnreadAllAnnounceListResponseDTO {
    func convertToHeader() -> BaseDetailAnnounceHeaderModel {
        return BaseDetailAnnounceHeaderModel(
            // TODO: - 놓친 공지사항 API 수정 후 해당 DTO 도 변경 (type 은 수정)
            type: .basic,
            name: affilitionName,
            image: logoImage,
            days: createdAt.formatDate(from: createdAt),
            favoriteCount: likeCount,
            bookmarkCount: saveCount,
            watchCount: readCount,
            isFavorite: likeCheck, 
            isBookmark: saveCheck, 
            isAuthor: isAuthor
        )
    }
    
    func convertToContent() -> DetailAnnouceContentModel {
        return DetailAnnouceContentModel(
            type: tag == "공지" ? .announce : .event,
            title: title,
            content: content
        )
    }
    
    func convertToImages() -> [DetailAnnouceImageModel]? {
        return images?.compactMap{ DetailAnnouceImageModel(image: $0) }
    }

    func convertToDateComponents(alarmTime: String?, components: Set<Calendar.Component>) -> DateComponents? {
        guard let alarmTime else { return nil }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "ko_KR")
        inputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let date = inputFormatter.date(from: alarmTime) else { return nil }
        
        let calendar = Calendar(identifier: .gregorian)
        return calendar.dateComponents(components, from: date)
    }
}
