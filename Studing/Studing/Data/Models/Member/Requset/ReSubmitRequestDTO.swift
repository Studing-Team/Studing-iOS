//
//  ReSubmitRequestDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/27/24.
//

import Foundation

struct ReSubmitRequestDTO: Encodable, ImageUploadable {
    let admissionNumber: String       // 입학년도 학번
    let name: String                  // 가입 사용자 이름
    let studentCardImage: Data        // 학생증 사진
}
