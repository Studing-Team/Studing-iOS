//
//  StoreEntity.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/7/24.
//

import Foundation

struct StoreEntity: Hashable {
    let id = UUID()
    let storeId: Int
    let name: String
    let category: CategoryType
    let description: String
    let address: String
    let imageURL: String
    let latitude: Double
    let longitude: Double
    var isExpanded: Bool = false
}
