//
//  SuccessSignUpViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/16/24.
//

import Foundation
import Combine

final class SuccessSignUpViewModel: BaseViewModel {
  
    // MARK: - Input
    
    struct Input {
        let mainHomeButtonTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let mainHomeViewAction: AnyPublisher<LoginResult, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let signInUseCase: SignInUseCase
    private let signupUserInfo: SignupUserInfo?
    
    init(signInUseCase: SignInUseCase,
         signupUserInfo: SignupUserInfo?
    ) {
        self.signInUseCase = signInUseCase
        self.signupUserInfo = signupUserInfo
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let loginResult = input.mainHomeButtonTap
            .flatMap { [weak self] _ -> AnyPublisher<LoginResult, Never> in
                print("버튼 눌림")
                guard let self, let signupUserInfo else { print("데이터 없음"); return
                    Just(.failure(.clientError(message: ""))).eraseToAnyPublisher() }
                
                return Future { promise in
                    Task {
                        let result = await self.signIn(userId: signupUserInfo.userId, userPw: signupUserInfo.password)
                        
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
            mainHomeViewAction: loginResult
        )
    }
}

// MARK: - API methods Extension

extension SuccessSignUpViewModel {
    func signIn(userId: String, userPw: String) async -> LoginResult {
        switch await signInUseCase.execute(loginRequest: LoginRequestDTO(loginIdentifier: userId, password: userPw)) {
        case .success(let response):
            KeychainManager.shared.save(key: .accessToken, value: response.accessToken)
            
            let userInfo = response.memberData.toEntity()
            
            KeychainManager.shared.saveData(key: .userAuthState, value: userInfo.role.rawValue)
            
            return .success
        case .failure(let error):
            return .failure(error)
        }
    }
}
