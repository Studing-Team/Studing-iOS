//
//  DetailAnnouceHeaderModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/5/24.
//

import Foundation

protocol DetailAnnouceSectionData {}

struct BaseDetailAnnounceHeaderModel: Hashable, DetailAnnouceSectionData {
    let id = UUID()
    let type: PostOptionType
    let name: String
    let image: String
    let days: String
    var favoriteCount: Int
    var bookmarkCount: Int
    var watchCount: Int
    var isFavorite: Bool
    var isBookmark: Bool
    let isAuthor: Bool
//    let isAlarm: Bool
//    let alarmTime: DateComponents?
}

struct DetailAnnouncePeriodHeaderModel: Hashable, DetailAnnouceSectionData {
    var base: BaseDetailAnnounceHeaderModel
    let startTime: String
    let endTime: String
}

struct DetailAnnounceFirstComeHeaderModel: Hashable, DetailAnnouceSectionData {
    var base: BaseDetailAnnounceHeaderModel
    let startTime: String
    let endTime: String
    var isFirstComeApplied: Bool
    var firstComeButtonState: FirstComeState
}
