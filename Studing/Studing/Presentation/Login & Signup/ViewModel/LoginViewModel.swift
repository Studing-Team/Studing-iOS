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
    private let notificationTokenUseCase: NotificationTokenUseCase
    
    init(signInUseCase: SignInUseCase,
         notificationTokenUseCase: NotificationTokenUseCase
    ) {
        self.signInUseCase = signInUseCase
        self.notificationTokenUseCase = notificationTokenUseCase
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
        
        let loginResult = input.loginTap
            .flatMap { [weak self] _ -> AnyPublisher<LoginResult, Never> in
                
                guard let self else { return Just(.failure(.clientError(message: ""))).eraseToAnyPublisher() }
                
                return Future { promise in
                    Task {
                        let loginResult = await self.signIn(userId: self.usernameSubject.value, userPw: self.passwordSubject.value)
                        
                        switch loginResult {
                        case .success:
                            let tokenResult = await self.saveNotificationToken()
                            switch tokenResult {
                            case .success:
                                promise(.success(.success))
                            case .failure(let error):
                                promise(.success(.failure(error)))
                            }
                        case .failure(let error):
                            promise(.success(.failure(error)))
                        }
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
    func signIn(userId: String, userPw: String) async -> LoginResult {
        switch await signInUseCase.execute(loginRequest: LoginRequestDTO(loginIdentifier: userId, password: userPw)) {
        case .success(let response):
            KeychainManager.shared.save(key: .accessToken, value: response.accessToken)
            
            return .success
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func saveNotificationToken() async -> Result<Void, NetworkError> {
        switch await notificationTokenUseCase.execute() {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
