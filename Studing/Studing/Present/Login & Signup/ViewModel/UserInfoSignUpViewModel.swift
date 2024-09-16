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
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let inputUserInfo = Publishers.CombineLatest3(input.userId, input.userPw, input.confirmPw)
        
        let isNextButtonEnabled = inputUserInfo
            .map { userId, userPw, confirmPw in
                !userId.isEmpty && !userPw.isEmpty && !confirmPw.isEmpty
            }
            .eraseToAnyPublisher()
        
        return Output(
            universityInfoViewAction: input.nextTap,
            isNextButtonEnabled: isNextButtonEnabled
        )
    }
}
