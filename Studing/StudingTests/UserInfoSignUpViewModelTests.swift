//
//  UserInfoSignUpViewModelTests.swift
//  StudingTests
//
//  Created by ParkJunHyuk on 9/16/24.
//

import XCTest
import Combine
@testable import Studing

final class UserInfoSignUpViewModelTests: XCTestCase {

    var viewModel: UserInfoSignUpViewModel!
    var cancellables: Set<AnyCancellable>!
    
    var userIdSubject: PassthroughSubject<String, Never>!
    var userPwSubject: PassthroughSubject<String, Never>!
    var confirmPwSubject: PassthroughSubject<String, Never>!
    var nextTapSubject: PassthroughSubject<Void, Never>!
    
    var input: UserInfoSignUpViewModel.Input!
    var output: UserInfoSignUpViewModel.Output!
    
    override func setUp() {
        super.setUp()
        viewModel = UserInfoSignUpViewModel()
        cancellables = []
        
        userIdSubject = PassthroughSubject<String, Never>()
        userPwSubject = PassthroughSubject<String, Never>()
        confirmPwSubject = PassthroughSubject<String, Never>()
        nextTapSubject = PassthroughSubject<Void, Never>()
        
        // Input 초기화
        input = UserInfoSignUpViewModel.Input(
            userId: userIdSubject.eraseToAnyPublisher(),
            userPw: userPwSubject.eraseToAnyPublisher(),
            confirmPw: confirmPwSubject.eraseToAnyPublisher(),
            nextTap: nextTapSubject.eraseToAnyPublisher()
        )
        
        // Output 초기화
        output = viewModel.transform(input: input)
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
}

extension UserInfoSignUpViewModelTests {
    
    /// 입력한 pw 와 확인하기 위한 pw 가 서로 일치하는지
    func testIsPasswordMatching() {
        
        var isPasswordMatching: Bool = false
        
        output.isPasswordMatching
            .sink { isMatching in
                isPasswordMatching = isMatching
            }.store(in: &cancellables)
        
        // 초기 상태: 비밀번호 필드가 비어있음
        XCTAssertEqual(isPasswordMatching, false)
        
        // 비밀번호만 입력
        userPwSubject.send("123456")
        XCTAssertEqual(isPasswordMatching, false)
        
        // 비밀번호와 확인이 일치
        confirmPwSubject.send("123456")
        XCTAssertEqual(isPasswordMatching, true)
        
        // 비밀번호와 확인이 불일치
        confirmPwSubject.send("123455")
        XCTAssertEqual(isPasswordMatching, false)
    }
    
    /// 유저 id, pw 를 입력하고
    func testIsNextButtonEnabled() {
        
        var isNextButtonEnabled: Bool?
        
        output.isNextButtonEnabled
            .sink { isEnabled in
                isNextButtonEnabled = isEnabled
            }
            .store(in: &cancellables)
        
        // 초기 상태: 모든 필드가 비어있음
        XCTAssertEqual(isNextButtonEnabled, false)
        
        // userId만 입력
        userIdSubject.send("testUserId")
        XCTAssertEqual(isNextButtonEnabled, false)
        
        // userId와 userPw 입력
        userPwSubject.send("testPassword")
        XCTAssertEqual(isNextButtonEnabled, false)
        
        // userId, userPw, confirmPw 입력 (일치)
        confirmPwSubject.send("testPassword")
        XCTAssertEqual(isNextButtonEnabled, true)
        
        // confirmPw를 불일치하게 변경
        confirmPwSubject.send("wrongPassword")
        XCTAssertEqual(isNextButtonEnabled, false)
        
        // 다시 모든 조건 충족
        confirmPwSubject.send("testPassword")
        XCTAssertEqual(isNextButtonEnabled, true)
    }
}
