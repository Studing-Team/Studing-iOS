//
//  DetailAnnounceResponseDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

struct DetailAnnounceResponseDTO: Decodable {
    let id: Int
    let title: String
    let content: String
    let likeCount: Int
    let saveCount: Int
    let readCount: Int
    let createdAt: String
    let logoImage: String
    let affilitionName: String
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

extension DetailAnnounceResponseDTO {
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
