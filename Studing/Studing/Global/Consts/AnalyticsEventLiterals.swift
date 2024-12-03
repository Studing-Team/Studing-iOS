//
//  AnalyticsEventLiterals.swift
//  Studing
//
//  Created by ParkJunHyuk on 12/2/24.
//

import Foundation

enum AnalyticsEvent {
    enum SignUp {
        /// step1 - 회원 정보 입력 화면에서 다음 버튼 클릭 시
        static let nextStep1 = "click_next_signup_step1"
        
        /// step2 - 학교 정보 입력 화면에서 다음 버튼 클릭 시
        static let nextStep2 = "click_next_signup_step2"
        
        /// step3 - 학과 정보 입력 화면에서 다음 버튼 클릭 시
        static let nextStep3 = "click_next_signup_step3"
        
        /// step4 - 학번 선택 화면에서 다음 버튼 클릭 시
        static let nextStep4 = "click_next_signup_step4"
        
        /// step5 - 서비스 이용약관 동의 화면에서 다음 버튼 클릭 시
        static let nextStep5 = "click_next_signup_step5"
        
        /// 학교 인증 화면에서 학생증 업로드 버튼 클릭 시
        static let nextStep6Upload = "click_next_signup_step6_upload"
        
        // 학교 인증 화면에서 다음 버튼 클릭 시
        static let nextStep6Complete = "click_next_signup_step6_complete"
        
        /// 학교 인증 진행 중 화면에서 알림 받기 버튼 클릭 시
        static let alarm = "click_next_signup_alarm"
        
        /// 학교 인증 진행 중 화면에서 스튜던 시작하기 버튼 클릭 시
        static let start = "click_next_signup_start"
        
        /// 환영합니다! 화면에서 스튜던 시작하기 버튼 클릭 시
        static let end = "click_next_signup_end"
    }
    
    enum Login {
        /// 로그인 화면에서 로그인 버튼 클릭 시
        static let login = "click_next_login"
        
        /// 로그인 화면에서 회원가입 버튼 클릭 시
        static let signup = "click_next_signup"
        
        /// 로그인 화면에서 문의하기 버튼 클릭 시
        static let askStuding = "click_contact_kakao_login"
        
        /// 잘못된 로그인 정보 입력 팝업 화면에서 다시 시도 버튼 클릭 시
        static let error = "click_login_error"
    }
    
    enum Home {
        /// 놓친 공지사항 버튼 클릭 시
        static let unreadNotice = "click_unread_notice_home"
        
        /// 전체 카테고리 버튼 클릭 시
        static let categoryAll = "click_category_all_home"
        
        /// 총학생회 카테고리 버튼 클릭 시
        static let categoryUniversity = "click_category_university_home"
        
        /// 단과대 학생회 카테고리 버튼 클릭 시
        static let categoryCollege = "click_category_college_home"
        
        // 학과 학생회 카테고리 버튼 클릭 시
        static let categoryDepartment = "click_category_department_home"
        
        /// 홈 화면에서 공지사항 더보기 버튼 클릭 시
        static let noticeList = "click_notice_list_home"
        
        /// 홈 화면에서 하나의 공지사항 클릭 시
        static let detailNotice = "click_detail_notice_home"
        
        // 홈 화면에서 저장한 공지사항 더보기 버튼 클릭 시
        static let saveList = "click_save_list_home"
        
        /// 홈 화면에서 저장한 공지사항 없는 경우, 전체 공지사항 보기 버튼 클릭 시
        static let nextNoticeListSave = "click_next_notice_list_save_home"
        
        /// 홈 화면에서 글 작성 버튼 클릭 시
        static let postNotice = "click_post_notice_home"
        
        /// 홈 화면에서 학생회 등록하기 버튼 클릭 시
        static let registerForm = "click_register_form_home"
    }
    
    enum UnreadNotice {
        /// 놓친 공지사항 화면에서 뒤로가기 버튼 클릭 시
        static let back = "click_back_unread"
        
        /// 놓친 공지사항 화면에서 좋아요 버튼 클릭 시
        static let likePost = "click_like_post_unread"
        
        /// 놓친 공지사항 화면에서 저장하기 버튼 클릭 시
        static let savePost = "click_save_post_unread"
        
        /// 놓친 공지사항 화면에서 다음 공지 버튼 클릭 시
        static let nextNotice = "click_next_notice_unread"
        
        /// 놓친 공지사항 마지막 화면에서 홈으로 돌아가기 버튼 클릭 시
        static let complete = "click_complete_unread"
    }
    
    enum NoticeList {
        /// 공지사항 리스트 화면에서 전체 카테고리 버튼 클릭 시
        static let categoryAll = "click_category_all_list"
        
        /// 공지사항 리스트 화면에서 총학생회 카테고리 버튼 클릭 시
        static let categoryUniversity = "click_category_university_list"
        
        /// 공지사항 리스트 화면에서 단과대 학생회 카테고리 버튼 클릭 시
        static let categoryCollege = "click_category_college_list"
        
        /// 공지사항 리스트 화면에서 학과 학생회 카테고리 버튼 클릭 시
        static let categoryDepartment = "click_category_department_list"
        
        /// 공지사항 리스트 화면에서 문의하기 버튼 클릭 시
        static let contactKakao = "click_contact_kakao_list"
        
        /// 공지사항 리스트 화면에서 하나의 공지사항 클릭 시
        static let detailNotice = "click_detail_notice_list"
        
        /// 공지사항 리스트 화면에서 학생회 등록하기 버튼 클릭 시
        static let registerForm = "click_register_form_list"
    }
    
    enum NoticeDetail {
        /// 세부 공지사항 화면에서 좋아요 버튼 클릭 시
        static let likePost = "click_like_post_detail"
        
        /// 세부 공지사항 화면에서 저장하기 버튼 클릭 시
        static let savePost = "click_save_post_detail"
    }
    
    enum NoticeCreate {
        /// 공지사항 작성 화면에서 등록하기 버튼 클릭 시
        static let upload = "click_upload_notice"
        
        /// 공지사항 작성 화면에서 사진 추가 버튼 클릭 시
        static let addPhoto = "click_add_photo"
    }
    
    enum Store {
        /// 제휴 화면에서 전체 카테고리 버튼 클릭 시
        static let categoryAll = "click_category_all_affiliate"
        
        /// 제휴 화면에서 음식점 카테고리 버튼 클릭 시
        static let categoryFood = "click_category_food_affiliate"
        
        /// 제휴 화면에서 카페 카테고리 버튼 클릭 시
        static let categoryCafe = "click_category_cafe_affiliate"
        
        /// 제휴 화면에서 주점 카테고리 버튼 클릭 시
        static let categoryDrink = "click_category_drink_affiliate"
        
        /// 제휴 화면에서 운동 카테고리 버튼 클릭 시
        static let categoryGym = "click_category_gym_affiliate"
        
        /// 제휴 화면에서 병원 카테고리 버튼 클릭 시
        static let categoryHospital = "click_category_hospital_affiliate"
        
        /// 제휴 화면에서 문화 카테고리 버튼 클릭 시
        static let categoryCulture = "click_category_culture_affiliate"
        
        /// 제휴 화면에서 제휴 혜택 버튼 클릭 시
        static let viewContent = "click_view_content_affiliate"
        
        /// 제휴 화면에서 지도 보기 버튼 클릭 시
        static let viewLocation = "click_view_location_affiliate"
        
        /// 제휴 화면에서 검색 텍스트필드 클릭 시
        static let search = "click_search_affiliate"
    }
    
    enum MyPage {
        /// 마이페이지에서 문의하기 버튼 클릭 시
        static let contact = "click_contact_mypage"
        
        // 마이페이지에서 로그아웃 버튼 클릭 시
        static let logout = "click_logout_mypage"
        
        /// 로그아웃 팝업에서 네 버튼 클릭 시
        static let logoutComplete = "click_logout_complete_mypage"
        
        /// 마이페이지에서 회원탈퇴 버튼 클릭 시
        static let signout = "click_signout_mypage"
        
        /// 회원탈퇴 팝업에서 네 버튼 클릭 시
        static let signoutComplete = "click_signout_complete_mypage"
    }
}

