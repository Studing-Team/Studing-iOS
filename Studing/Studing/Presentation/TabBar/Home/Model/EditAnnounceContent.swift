//
//  EditAnnounceContent.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/19/25.
//

import Foundation

struct EditAnnounceContent {
    let noticeId: Int
    let title: String
    let image: [String]?
    let content: String
    let tag: String
    let startDay: DateComponents?
    let startTime: DateComponents?
    let endDay: DateComponents?
    let endTime: DateComponents?
}
