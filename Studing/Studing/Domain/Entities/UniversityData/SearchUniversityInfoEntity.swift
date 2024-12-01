//
//  SearchUniversityInfoEntity.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

struct SearchUniversityInfoEntity: Decodable {
    let data: [String]
}

struct UniversityInfoEntity: SearchResultModel, Identifiable, Decodable {
    let id: UUID
    let resultData: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.resultData = name
    }
}
