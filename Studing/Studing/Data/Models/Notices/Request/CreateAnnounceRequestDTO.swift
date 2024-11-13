//
//  CreateAnnouceRequestDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import Foundation

struct CreateAnnounceRequestDTO: Codable {
    let title: String
    let content: String
    let noticeImages: [Data]
    let tag: String
}
