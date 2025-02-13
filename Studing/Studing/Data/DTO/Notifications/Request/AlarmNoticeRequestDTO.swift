//
//  AlarmNoticeRequestDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/5/25.
//

import Foundation

struct AlarmNoticeRequestDTO: Codable {
    let year: Int
    let month: Int
    let day: Int
    let hour: Int
    let minute: Int
}
