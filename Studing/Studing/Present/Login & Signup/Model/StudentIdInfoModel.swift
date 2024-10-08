//
//  StudentIdInfoModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/8/24.
//

import Foundation

struct StudentIdInfoModel {
    let id: UUID
    let studentId: String
    
    init(id: UUID = UUID(), studentId: String) {
        self.id = id
        self.studentId = studentId
    }
}
