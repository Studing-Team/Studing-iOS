//
//  UniversityInfoModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/3/24.
//

import Foundation

struct SearchUniversityInfoResponseDTO: Decodable {
    let data: [String]
}

struct UniversityInfoModel: SearchResultModel, Identifiable, Decodable {
    let id: UUID
    let resultData: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.resultData = name
    }
}
