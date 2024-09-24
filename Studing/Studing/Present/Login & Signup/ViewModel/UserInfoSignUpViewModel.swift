//
//  UserInfoSignUpViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import Foundation
import Combine

final class UserInfoSignUpViewModel: BaseViewModel {
    
    // MARK: - Input
    
    struct Input {
        let userId: AnyPublisher<String, Never>
        let userPw: AnyPublisher<String, Never>
        let confirmPw: AnyPublisher<String, Never>
        let nextTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let universityInfoViewAction: AnyPublisher<Void, Never>
        let isNextButtonEnabled: AnyPublisher<Bool, Never>
        let userIdState: AnyPublisher<TextFieldState, Never>
        let userPwState: AnyPublisher<TextFieldState, Never>
        let confirmPwState: AnyPublisher<TextFieldState, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let inputUserInfo = Publishers.CombineLatest3(input.userId, input.userPw, input.confirmPw)
        
        let userIdState = input.userId
            .map { [weak self] userId -> TextFieldState in
                // 여기에 userId 유효성 검사 로직을 추가할 수 있습니다.
                self?.validateUserId(userId) ?? .normal
            }
            .eraseToAnyPublisher()
        
        let userPwState = input.userPw
            .map { [weak self] userPw -> TextFieldState in
                // 여기에 userPw 유효성 검사 로직을 추가할 수 있습니다.
                self?.validateUserPw(userPw) ?? .normal
            }
            .eraseToAnyPublisher()
        
        let confirmPwState = Publishers.CombineLatest(input.userPw, input.confirmPw)
            .map { [weak self] userPw, confirmPw in
                //  return userPw == confirmPw && !userPw.isEmpty
                self?.validateConfirmPw(userPw, confirmPw) ?? .normal
            }
            .eraseToAnyPublisher()
        
        let isNextButtonEnabled = Publishers.CombineLatest3(userIdState, userPwState, confirmPwState)
            .map { userIdState, userPwState, confirmPwState in
                if case .success = userIdState,
                   case .success = userPwState,
                   case .success = confirmPwState {
                    return true
                } else {
                    return false
                }
            }
            .prepend(false)
            .eraseToAnyPublisher()
        
        return Output(
            universityInfoViewAction: input.nextTap,
            isNextButtonEnabled: isNextButtonEnabled,
            userIdState: userIdState,
            userPwState: userPwState,
            confirmPwState: confirmPwState
        )
    }
}

private extension UserInfoSignUpViewModel {
    func validateUserId(_ userId: String) -> TextFieldState {
        if userId.count >= 6 && userId.count <= 12 && userId.rangeOfCharacter(from: .alphanumerics) != nil {
            return .success(type: .userId)
        } else {
            return .invalid(type: .userId)
        }
    }
    
    func validateUserPw(_ userPw: String) -> TextFieldState {
        if userPw.count >= 8 && userPw.count <= 16 {
            return .success(type: .userPw)
        } else {
            return .invalid(type: .userPw)
        }
    }
    
    func validateConfirmPw(_ userPw: String, _ confirmPw: String) -> TextFieldState {
        if userPw == confirmPw && !userPw.isEmpty {
            return .success(type: .confirmPw)
        } else {
            return .invalid(type: .confirmPw)
        }
    }
}
