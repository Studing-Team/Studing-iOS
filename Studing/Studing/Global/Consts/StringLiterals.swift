//
//  StringLiterals.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import Foundation

enum StringLiterals {
    enum NavigationTitle {
        static let signUp = "회원가입"
        static let authUniversity = "학교 인증"
    }
    
    enum Title {
        static let authUserInfo = "회원 정보를 입력해주세요"
        static let authUniversity = "학교 정보를 입력해주세요"
        static let authMajor = "학과 정보를 입력해주세요"
        static let authStudentID = "학번을 선택해주세요"
        static let authTermsofService = "서비스 이용을 위해\n이용약관 동의가 필요해요"
        static let authUniversityStudent = "학교 인증을 통해\n스튜딩을 시작할 수 있어요!"
        static let authenticatingTitle = "학교 인증을 진행 중이에요 :)"
        
        static let noExistsSerachUniversity = "찾으시는 대학교가 없으신가요?"
        static let noExistsSerachMajor = "찾으시는 학과가 없으신가요?"
    }
    
    enum SubTitle {
        static let noExistsSerachUniversity = "아래 버튼을 눌러 구글폼을 통해 우리 학교를 등록해요.\n3일 이내로 빠르게 추가해드릴게요!"
        static let noExistsSerachMajor = "아래 버튼을 눌러 구글폼을 통해 나의 학과를 등록해요.\n3일 이내로 빠르게 추가해드릴게요!"
    }
    
    enum Button {
        static let nextTitle = "다음"
        static let authTitle = "인증하기"
        static let notificationSetting = "알림 설정하기"
        static let pushMainHomeTitle = "메인 홈으로 가기"
    }
    
    enum Authentication {
        static let universityTitle = "학생증으로 학교 인증을 해주세요"
        static let universitySubTitle = "실물 학생증 또는 모바일 학생증 이미지를 첨부해주세요\n승인까지 최대 24시간이 걸릴 수 있어요 :)"
        static let studentCardTitle = "이곳을 클릭해서 이미지를 업로드해주세요!"
        static let AuthenticatingTitle2 = "24시간 이내로 승인 여부를 알려드릴게요."
        static let AuthenticatingSubTitle1 = "입력한 정보와 제출한 정보가\n일치하는지 확인 중이에요"
        static let AuthenticatingSubTitle2 = "학교 인증이 완료된 이후에\n스튜딩의 모든 기능을 이용할 수 있어요."
        static let AuthenticatingSubTitle3 = "알림 받기로 승인 여부를 빠르게 확인할까요?"
        static let successSignUpTitle = "환영합니다!"
        static let successSignUpSubTitle = "스튜딩과 함께 대학생의 모든 것을 즐겨봐요"
    }
}
