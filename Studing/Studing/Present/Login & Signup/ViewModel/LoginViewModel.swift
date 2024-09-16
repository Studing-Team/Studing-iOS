//
//  LoginViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import Foundation
import Combine

final class LoginViewModel: BaseViewModel {
    
    // MARK: - Input
    
    struct Input {
        let username: AnyPublisher<String, Never>
        let password: AnyPublisher<String, Never>
        let signUpTap: AnyPublisher<Void, Never>
        let loginTap: AnyPublisher<Void, Never>
        let kakaoTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let signUpAction: AnyPublisher<Void, Never>
        let isLoginButtonEnabled: AnyPublisher<Bool, Never>
        let loginResult: AnyPublisher<Result<UserInfo, Error>, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        let inputUserInfo = Publishers.CombineLatest(input.username, input.password)
        
        let isLoginButtonEnabled = inputUserInfo
            .map { username, password in
                !username.isEmpty && !password.isEmpty
            }
            .eraseToAnyPublisher()

        let loginResult = Publishers.CombineLatest(input.loginTap, inputUserInfo)
            .flatMap { [weak self] (_, userInfo) -> AnyPublisher<Result<UserInfo, Error>, Never> in
                
                guard let self = self else {
                    return Just(Result<UserInfo, Error>.failure(NSError(domain: "LoginViewModel", code: 0, userInfo: nil)))
                        .eraseToAnyPublisher()
                }
                
                let (userId, userPw) = userInfo
                return self.performLogin(userId: userId, userPw: userPw)
            }
            .eraseToAnyPublisher()
        
        return Output(
            signUpAction: input.signUpTap,
            isLoginButtonEnabled: isLoginButtonEnabled,
            loginResult: loginResult
        )
    }
}

// MARK: - API methods Extension

extension LoginViewModel {
    func performLogin(userId: String, userPw: String) -> AnyPublisher<Result<UserInfo, Error>, Never> {
        
        // TODO: - 로그인 API 가 완성됐을 때 호출 (지금은 테스트를 위한 설정)
        
        return Future<Result<UserInfo, Error>, Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if userId == "test" && userPw == "123456" {
                    let user = UserInfo(userName: "Niro")
                    promise(.success(.success(user)))
                } else {
                    promise(.success(.failure(NSError(domain: "Login", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"]))))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
