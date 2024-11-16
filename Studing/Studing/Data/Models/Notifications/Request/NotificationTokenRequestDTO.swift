//
//  NotificationTokenRequestDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/14/24.
//

import Foundation

struct NotificationTokenRequestDTO: Codable {
    let fcmToken: String
    let memberId: Int
}
