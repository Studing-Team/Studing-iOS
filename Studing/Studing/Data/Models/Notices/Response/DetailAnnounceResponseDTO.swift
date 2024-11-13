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
    let linkCount: Int
    let saveCount: Int
    let readCount: Int
    let createdAt: String
    let affilitionName: String
    let logoImage: String
    let tag: String
    let images: [String]
    let saveCheck: Bool
    let linkCheck: Bool
}
