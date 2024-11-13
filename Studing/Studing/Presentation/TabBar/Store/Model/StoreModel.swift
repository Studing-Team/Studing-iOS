//
//  StoreModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/7/24.
//

import Foundation

struct StoreModel: Hashable {
    let id = UUID()
    let name: String
    let category: CategoryType
    let description: String
    let address: String
    let imageURL: String
    var isExpanded: Bool = false
}
