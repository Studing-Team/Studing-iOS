//
//  SignUpStore.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/12/24.
//

import Foundation

struct SignupUserInfo: Codable {
    let userId: String
    let password: String
    let university: String
    let major: String
    let admission: String
    let marketing: Bool
}

// 사용자 기본 정보 관련
protocol UserInfoStoreProtocol {
    var userId: String? { get }
    var password: String? { get }
    
    func setUserId(_ id: String)
    func setPassword(_ password: String)
}

// 학교 정보 관련
protocol UniversityInfoStoreProtocol {
    var university: String? { get }
    var major: String? { get }
    var admission: String? { get }
    
    func setUniversity(_ university: String)
    func setMajor(_ major: String)
    func setAdmission(_ admission: String)
}

// 학생 정보 관련
protocol StudentInfoStoreProtocol {
    var studentCardImage: Data? { get }
    var userName: String? { get }
    var studentNumber: String? { get }
    
    func setStudentCardImage(_ image: Data)
    func setUserName(_ name: String)
    func setStudentNumber(_ number: String)
}

final class SignUpStore: UserInfoStoreProtocol, UniversityInfoStoreProtocol {
    private(set) var userId: String?
    private(set) var password: String?
    private(set) var university: String?
    private(set) var major: String?
    private(set) var admission: String?
    private(set) var marketing: Bool?
    //    private(set) var studentCardImage: Data?
    //    private(set) var userName: String?
    //    private(set) var studentNumber: String?
    
    init() {
        print("SignUpStore init")
    }
    
    deinit {
        print("SignUpStore deinit")
    }
    
    func setUserId(_ id: String) {
        print("유저 아이디 입력:", id)
        self.userId = id
    }
    
    func setPassword(_ password: String) {
        print("유저 비밀번호 입력:", password)
        self.password = password
    }
    
    func setUniversity(_ university: String) {
        print("대학교 입력:", university)
        self.university = university
    }
    
    func setMajor(_ major: String) {
        print("학과 입력:", major)
        self.major = major
    }
    
    func setAdmission(_ admission: String) {
        print("입학연도 입력:", admission)
        self.admission = admission
    }
    
    func setMarketing(_ isMarketing: Bool) {
        print("마켓팅 수신동의 입력:", isMarketing)
        self.marketing = isMarketing
    }
    
    func getUserData() -> SignupUserInfo? {
        guard let userId = userId,
              let password = password,
              let admission = admission,
              let marketing = marketing,
              let university = university,
              let major = major else {
            print("❌ 회원가입에 필요한 데이터가 부족합니다")
            return nil
        }
        
        let info = SignupUserInfo(
            userId: userId,
            password: password,
            university: university,
            major: major,
            admission: admission,
            marketing: marketing
        )
        
        KeychainManager.shared.saveData(key: .signupInfo, value: info)
        
        return info
    }
    
//    func setStudentCardImage(_ image: Data) {
//        print("학생증 입력")
//        self.studentCardImage = image
//    }
//    
//    func setUserName(_ name: String) {
//        print("유저 이름 입력:", name)
//        self.userName = name
//    }
//    
//    func setStudentNumber(_ number: String) {
//        print("유저 학번 입력:", number)
//        self.studentNumber = number
//    }
    
//    func getUserData() -> SignupRequestDTO? {
//       // 필요한 모든 데이터가 있는지 확인
//       guard let userId = userId,
//             let password = password,
//             let admission = admission,
//             let studentNumber = studentNumber,
//             let userName = userName,
//             let marketing = marketing,
//             let university = university,
//             let major = major,
//             let studentCardImage = studentCardImage else {
//           print("❌ 회원가입에 필요한 데이터가 부족합니다")
//           return nil
//       }
//       
//       return SignupRequestDTO(
//           loginIdentifier: userId,
//           password: password,
//           admissionNumber: admission,
//           name: userName,
//           studentNumber: studentNumber,
//           memberUniversity: university,
//           memberDepartment: major,
//           studentCardImage: studentCardImage,
//           marketingAgreement: marketing
//       )
//   }
//    
//    func clear() {
//        userId = nil
//        password = nil
//        university = nil
//        major = nil
//        admission = nil
//        marketing = nil
//        studentCardImage = nil
//        userName = nil
//        studentNumber = nil
//    }
}
