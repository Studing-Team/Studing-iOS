//
//  DetailAnnounceEntity.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/27/25.
//

import Foundation

struct DetailAnnounceEntity: Decodable {
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
    let alarmDay: DateComponents?
    let alarmTime: DateComponents?
    let firstComeNumber: Int?
    
    var type: PostOptionType {
        if let startTime, let endTime {
            if isFirstComeNotice == true {
                return .firstCome
            } else {
                return .period
            }
        } else {
            return .basic
        }
    }
    
    var isAlarmSet: Bool {
        return alarmTime != nil
    }
}

extension DetailAnnounceEntity {
    func toContentModel() -> DetailAnnouceContentModel {
        return DetailAnnouceContentModel(
            type: tag == "공지" ? .announce : .event,
            title: title,
            content: content
        )
    }
    
    func toImagesModel() -> [DetailAnnouceImageModel]? {
        guard let images = images, !images.isEmpty else { return nil }
        return images.map { DetailAnnouceImageModel(image: $0) }
    }
    
    func toHeaderModel() -> DetailAnnouceSectionData {
        switch type {
        case .basic:
            return toBaseHeaderModel()
            
        case .period:
            return toPeriodHeaderModel(
                startTime: startTime, 
                endTime: endTime
            )
            
        case .firstCome:
            return toFirstComeHeaderModel(
                startTime: startTime,
                endTime: endTime,
                isFirstComeApplied: isFirstComeApplied
            )
        }
    }
}


private extension DetailAnnounceEntity {
    func toBaseHeaderModel() -> BaseDetailAnnounceHeaderModel {
        return BaseDetailAnnounceHeaderModel(
            type: type,
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

    func toPeriodHeaderModel(startTime: String?, endTime: String?) -> DetailAnnouncePeriodHeaderModel {
        
        guard let startTime, let endTime else { return DetailAnnouncePeriodHeaderModel(
            base: toBaseHeaderModel(),
            startTime: "정보 없음",
            endTime: "정보 없음")
        }
        
        return DetailAnnouncePeriodHeaderModel(
            base: toBaseHeaderModel(),
            startTime: convertToKoreanTimeFormat(from: startTime),
            endTime: convertToKoreanTimeFormat(from: endTime)
        )
    }

    func toFirstComeHeaderModel(startTime: String?, endTime: String?, isFirstComeApplied: Bool) -> DetailAnnounceFirstComeHeaderModel {
        
        guard let startTime, let endTime else { return DetailAnnounceFirstComeHeaderModel(
            base: toBaseHeaderModel(),
            startTime: "정보 없음",
            endTime: "정보 없음",
            isFirstComeApplied: false,
            firstComeButtonState: .active)
        }
        
        return DetailAnnounceFirstComeHeaderModel(
            base: toBaseHeaderModel(),
            startTime: convertToKoreanTimeFormat(from: startTime),
            endTime: convertToKoreanTimeFormat(from: endTime),
            isFirstComeApplied: isFirstComeApplied,
            firstComeButtonState: convertFirstComeState(startTime: startTime, endTime: endTime)
        )
    }
    
    func convertToKoreanTimeFormat(from isoString: String) -> String {
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        isoFormatter.locale = Locale(identifier: "ko_KR")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy년 M월 d일 HH:mm"
        outputFormatter.locale = Locale(identifier: "ko_KR")

        if let date = isoFormatter.date(from: isoString) {
            return outputFormatter.string(from: date)
        } else {
            return "잘못된 날짜 형식"
        }
    }
    
    func convertFirstComeState(startTime: String, endTime: String) -> FirstComeState {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        guard let start = dateFormatter.date(from: startTime),
              let end = dateFormatter.date(from: endTime) else {
            print("❌ 날짜 변환 실패")
            return .wait
        }
        
        let now = Date()

         if now < start {
             return .wait
         } else if now >= start && now <= end {
             return .active
         } else {
             return .end
         }
    }
}
