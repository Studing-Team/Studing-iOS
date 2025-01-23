//
//  TextFieldInputTypeEnum.swift
//  Studing
//
//  Created by ParkJunHyuk on 12/12/24.
//

import Foundation

/// `TextFieldInputType` 열거형은 텍스트 필드의 입력 유형을 정의합니다.
/// 사용자 계정 관련 필드(아이디, 비밀번호), 개인정보 필드(이름),
/// 학교 관련 필드(학번, 대학교, 전공) 등 다양한 입력 타입을 관리하며,
/// 각 타입에 대한 제목과 플레이스홀더 텍스트를 제공합니다.
///
/// - Note: 각 케이스는 특정 입력 필드의 용도를 나타내며, 이를 통해 적절한 유효성 검사와
///            사용자 인터페이스를 구성할 수 있습니다.
/// ## 열거형의 각 케이스
///   - `userId`: 사용자 아이디 입력 필드
///   - `userPw`: 비밀번호 입력 필드
///   - `confirmPw`: 비밀번호 확인 입력 필드
///   - `userName`: 사용자 이름 입력 필드
///   - `studentId`: 학번 선택 필드
///   - `university`: 대학교 입력 필드
///   - `major`: 전공학과 입력 필드
///   - `allStudentId`: 전체 학번 입력 필드
///
/// ## 주요 프로퍼티
///   - `title`: 각 입력 필드의 제목을 반환합니다.
///   - `placeholder`: 각 입력 필드의 플레이스홀더 텍스트를 반환합니다.
///
enum TextFieldInputType {
   /// 사용자 아이디 입력을 위한 케이스
   case userId
   
   /// 비밀번호 입력을 위한 케이스
   case userPw
   
   /// 비밀번호 확인 입력을 위한 케이스
   case confirmPw
   
   /// 사용자 이름 입력을 위한 케이스
   case userName
   
   /// 학번 선택을 위한 케이스
   case studentId
   
   /// 대학교 입력을 위한 케이스
   case university
   
   /// 전공학과 입력을 위한 케이스
   case major
   
   /// 전체 학번 입력을 위한 케이스
   case allStudentId
   
   /// 각 입력 필드의 제목을 반환하는 계산 프로퍼티
   var title: String {
       switch self {
       case .userId:
           return "아이디(최대 12자)"
       case .userPw:
           return "비밀번호"
       case .confirmPw:
           return "비밀번호 확인"
       case .userName:
           return "이름"
       case .studentId:
           return "학번"
       case .university:
           return "대학교"
       case .major:
           return "전공학과"
       case .allStudentId:
           return "전체 학번"
       }
   }
   
   /// 각 입력 필드의 플레이스홀더 텍스트를 반환하는 계산 프로퍼티
   var placeholder: String {
       switch self {
       case .userId:
           return "ex. studing24"
       case .userPw:
           return "8자리 이상 입력해주세요"
       case .confirmPw:
           return "비밀번호를 다시 한 번 확인할게요"
       case .userName:
           return "이름을 입력해주세요"
       case .studentId:
           return "학번을 선택해주세요"
       case .university:
           return "대학교를 입력해주세요"
       case .major:
           return "학과를 입력해주세요"
       case .allStudentId:
           return "ex. 202021234"
       }
   }
}
