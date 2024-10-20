//
//  AssociationModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import Foundation

struct AssociationModel: Hashable, HomeSectionData {
    let id = UUID()
    let name: String
    let image: String
    var isSelected: Bool
}
