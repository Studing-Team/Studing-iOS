//
//  LoginViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import Foundation
import Combine

enum LoginResult {
    case success
    case failure(NetworkError)
}

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
        let loginResult: AnyPublisher<LoginResult, Never>
    }
    
    // MARK: - Private properties
    
    private let usernameSubject = CurrentValueSubject<String, Never>("")
    private let passwordSubject = CurrentValueSubject<String, Never>("")
    private var cancellables = Set<AnyCancellable>()
    
    private let signInUseCase: SignInUseCase
    
    init(signInUseCase: SignInUseCase) {
        self.signInUseCase = signInUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        input.username
            .sink { [weak self] text in
                self?.usernameSubject.send(text)
            }
            .store(in: &cancellables)
        
        input.password
            .sink { [weak self] text in
                self?.passwordSubject.send(text)
            }
            .store(in: &cancellables)
        
        let isLoginButtonEnabled = Publishers.CombineLatest(input.username, input.password)
            .map { username, password in
                !username.isEmpty && !password.isEmpty
            }
            .eraseToAnyPublisher()

//        let loginResult = Publishers.Zip(input.loginTap, inputUserInfo)
//            .flatMap { [weak self] (_, userInfo) -> AnyPublisher<LoginResult, Never> in
//                
//                guard let self else { return Just(.failure(.clientError(message: ""))).eraseToAnyPublisher() }
//                
//                let (userId, userPw) = userInfo
//                return Future { promise in
//                    Task {
//                        let result = await self.signIn(userId: userId, userPw: userPw)
//                        promise(.success(result))
//                    }
//                } .eraseToAnyPublisher()
//            }
//            .eraseToAnyPublisher()
        
        let loginResult = input.loginTap
            .flatMap { [weak self] _ -> AnyPublisher<LoginResult, Never> in
                
                guard let self else { return Just(.failure(.clientError(message: ""))).eraseToAnyPublisher() }
                
                return Future { promise in
                    Task {
                        let result = await self.signIn(userId: self.usernameSubject.value, userPw: self.passwordSubject.value)
                        promise(.success(result))
                    }
                } .eraseToAnyPublisher()
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
    
    
    func signIn(userId: String, userPw: String) async -> LoginResult {
        switch await signInUseCase.execute(loginRequest: LoginRequestDTO(loginIdentifier: userId, password: userPw)) {
        case .success(let response):
            KeychainManager.shared.save(key: .accessToken, value: response.accessToken)
            
            return .success
        case .failure(let error):
            return .failure(error)
        }
    }
}
