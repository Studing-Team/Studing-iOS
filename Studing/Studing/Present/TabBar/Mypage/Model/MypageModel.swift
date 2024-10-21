//
//  MypageModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import Foundation

/// `MypageModel`은 마이페이지에서 사용자 정보를 보여주기 위한 데이터 모델입니다.
/// 이 구조체는 사용자의 ID, 이름, 프로필 이미지, 대학교, 학과, 학번 정보를 포함합니다.
///
/// - Fields:
///   - id: 고유한 사용자 식별자 (UUID)
///   - userName: 사용자의 이름
///   - university: 사용자의 대학교
///   - major: 사용자의 학과
///   - studentId: 사용자의 학번
struct MypageModel: Hashable {
    let id = UUID()
    let userName: String
    let university: String
    let major: String
    let studentId: String
}
