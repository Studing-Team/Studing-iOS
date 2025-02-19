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
    let firstComeNumber: Int?
}

extension UnreadAllAnnounceListResponseData {
    func toEntities() -> [DetailAnnounceEntity] {
        var result = [DetailAnnounceEntity]()
        
        result = self.notices.map{ $0.toEntity() }
        
        return result
    }
}

extension UnreadAllAnnounceListResponseDTO {
    func toEntity() -> DetailAnnounceEntity {
        return DetailAnnounceEntity(
            id: id,
            title: title,
            content: content,
            likeCount: likeCount,
            saveCount: saveCount,
            readCount: readCount,
            createdAt: createdAt,
            logoImage: logoImage,
            affilitionName: affilitionName,
            tag: tag,
            images: images,
            saveCheck: saveCheck,
            likeCheck: likeCheck,
            isAuthor: isAuthor,
            startTime: startTime,
            endTime: endTime,
            isFirstComeNotice: isFirstComeNotice,
            isFirstComeApplied: isFirstComeApplied,
            alarmDay: convertToDateComponents(alarmTime: alarmTime, components: [.year, .month, .day]),
            alarmTime: convertToDateComponents(alarmTime: alarmTime, components: [.hour, .minute]),
            firstComeNumber: firstComeNumber
        )
    }
}
