//
//  SignupRequsetDTO.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

struct SignupRequestDTO: Encodable {
    let loginIdentifier: String        // 가입 요청 아이디
    let password: String              // 가입요청 비밀번호
    let admissionNumber: String       // 입학년도 학번
    let name: String                  // 가입 사용자 이름
    let studentNumber: String         // 학교고유 학번
    let memberUniversity: String      // 사용자 대학교이름
    let memberDepartment: String      // 사용자 대학교 학과
    let studentCardImage: Data        // 학생증 사진
}
