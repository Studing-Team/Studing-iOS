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
        let askTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let signUpAction: AnyPublisher<Void, Never>
        let isLoginButtonEnabled: AnyPublisher<Bool, Never>
        let loginResult: AnyPublisher<LoginResult, Never>
        let askButtonTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Private properties
    
    private let usernameSubject = CurrentValueSubject<String, Never>("")
    private let passwordSubject = CurrentValueSubject<String, Never>("")
    private var cancellables = Set<AnyCancellable>()
    
    private let signInUseCase: SignInUseCase
    
    init(signInUseCase: SignInUseCase
    ) {
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
        
        let loginResult = input.loginTap
            .flatMap { [weak self] _ -> AnyPublisher<LoginResult, Never> in
                
                guard let self else { return Just(.failure(.clientError(message: ""))).eraseToAnyPublisher() }
                
                return Future { promise in
                    Task {
                        let result = await self.signIn(userId: self.usernameSubject.value, userPw: self.passwordSubject.value)
                        
                        switch result {
                        case .success:
                            promise(.success(.success))
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
            loginResult: loginResult,
            askButtonTap: input.askTap
        )
    }
}

// MARK: - API methods Extension

extension LoginViewModel {
    func signIn(userId: String, userPw: String) async -> LoginResult {
        switch await signInUseCase.execute(loginRequest: LoginRequestDTO(loginIdentifier: userId, password: userPw)) {
        case .success(let response):
            KeychainManager.shared.save(key: .accessToken, value: response.accessToken)
            
            let userInfo = response.memberData.toEntity()
            
            let userData = UserInfo(userName: userInfo.name, university: userInfo.memberUniversity, department: userInfo.memberDepartment, identifier: userInfo.loginIdentifier)
            
            KeychainManager.shared.saveData(key: .userAuthState, value: userInfo.role.rawValue)
            KeychainManager.shared.saveData(key: .userInfo, value: userData)
            
            UserDefaults.standard.set(true, forKey: "isLogined")
            
            return .success
        case .failure(let error):
            return .failure(error)
        }
    }
}

struct UserInfo: Codable {
    let userName: String
    let university: String
    let department: String
    let identifier: String
}
