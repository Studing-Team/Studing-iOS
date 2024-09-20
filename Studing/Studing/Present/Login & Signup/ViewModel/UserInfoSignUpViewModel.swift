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
        let isPasswordMatching: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let inputUserInfo = Publishers.CombineLatest3(input.userId, input.userPw, input.confirmPw)
        
        let isPasswordMatching = Publishers.CombineLatest(input.userPw, input.confirmPw)
            .map { userPw, confirmPw in
                return userPw == confirmPw && !userPw.isEmpty
            }
            .eraseToAnyPublisher()
        
        let isNextButtonEnabled = Publishers.CombineLatest(inputUserInfo, isPasswordMatching)
            .map { (userInfo, isMatching) -> Bool in
                let (userId, userPw, confirmPw) = userInfo
                return !userId.isEmpty && !userPw.isEmpty && !confirmPw.isEmpty && isMatching
            }
            .prepend(false)
            .eraseToAnyPublisher()
        
        return Output(
            universityInfoViewAction: input.nextTap,
            isNextButtonEnabled: isNextButtonEnabled,
            isPasswordMatching: isPasswordMatching        
        )
    }
}
