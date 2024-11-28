//
//  AssociationModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import Foundation

struct AssociationEntity: Hashable, HomeSectionData {
    let id = UUID()
    let name: String
    let image: String
    let associationType: AssociationType?
    var isSelected: Bool
    var unRead: Bool
    var isRegisteredDepartment: Bool
}
