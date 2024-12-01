//
//  CategoryEntity.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/6/24.
//

import Foundation

struct CategoryEntity: Hashable {
    let id = UUID()
    let name: String
    let type: CategoryType
    var isSelected: Bool
}
