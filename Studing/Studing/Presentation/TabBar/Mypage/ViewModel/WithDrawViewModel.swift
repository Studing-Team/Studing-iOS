//
//  WithDrawViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/26/24.
//

import Combine
import Foundation

final class WithDrawViewModel: BaseViewModel {
    
    // MARK: - UseCase properties
    
    private let withDrawUseCase: WithDrawUseCase
    
    // MARK: - Input
    
    struct Input {
        let cancelButtonAction: AnyPublisher<Void, Never>
        let withDrawButtonAction: AnyPublisher<Void, Never>
        let comfirmButtonAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let cancelButtonResult: AnyPublisher<Void, Never>
        let withDrawButtonResult: AnyPublisher<Void, Never>
        let comfirmButtonResult: AnyPublisher<Bool, Never>
    }
    
    // MARK: - init
    
    init(withDrawUseCase: WithDrawUseCase) {
        self.withDrawUseCase = withDrawUseCase
    }

    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let comfirmButtonResult = input.comfirmButtonAction
            .flatMap { [weak self] _ -> AnyPublisher<Bool, Never> in
                
                guard let self else { return Just(false).eraseToAnyPublisher() }
                
                return Future { promise in
                    Task {
                        let result = await self.deleteWithDrawUser()
                        
                        switch result {
                        case .success:
                            KeychainManager.shared.delete(key: .userInfo)
                            KeychainManager.shared.delete(key: .userAuthState)
                            KeychainManager.shared.delete(key: .accessToken)
                            KeychainManager.shared.delete(key: .signupInfo)
                            KeychainManager.shared.delete(key: .fcmToken)
                            
                            AmplitudeManager.shared.trackEvent(AnalyticsEvent.MyPage.signoutComplete)
                            
                            promise(.success(true))
                        case .failure:
                            promise(.success(false))
                        }
                    }
                }.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
        
        
        return Output(
            cancelButtonResult: input.cancelButtonAction,
            withDrawButtonResult: input.withDrawButtonAction,
            comfirmButtonResult: comfirmButtonResult
        )
    }
}

// MARK: - API methods Extension

extension WithDrawViewModel {
    /// 회원 탈퇴를 위한 메서드
    func deleteWithDrawUser() async -> Result<Void, NetworkError> {
        switch await withDrawUseCase.execute() {
        case .success:
            return .success(())
        case .failure(let error):
            print("Error:", error.localizedDescription)
            return .failure(error)
        }
    }
}
