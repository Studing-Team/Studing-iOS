//
//  SearchMajorInfoEntity.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

struct SearchMajorInfoEntity: Decodable {
    let data: [String]
}

struct MajorInfoEntity: SearchResultModel, Identifiable, Decodable {
    let id: UUID
    let resultData: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.resultData = name
    }
}
