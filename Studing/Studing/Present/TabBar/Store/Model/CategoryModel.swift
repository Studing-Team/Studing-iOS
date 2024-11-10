//
//  CategoryModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/6/24.
//

import Foundation

struct CategoryModel: Hashable {
    let id = UUID()
    let name: String
    var isSelected: Bool
}
