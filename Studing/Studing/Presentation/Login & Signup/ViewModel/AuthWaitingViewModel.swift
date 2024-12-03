//
//  AuthWaitingViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/15/24.
//

import Foundation
import Combine

final class AuthWaitingViewModel: BaseViewModel {
  
    // MARK: - Input
    
    struct Input {
        let showStudingTap: AnyPublisher<Void, Never>
        let notificationTap: AnyPublisher<Void, Never>
        let permissionGrantedTap: AnyPublisher<Void, Never>
        let permissionDeniedTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let showStudingViewAction: AnyPublisher<Void, Never>
        let notificationTapAction: AnyPublisher<Void, Never>
        let permissionGrantedResult: AnyPublisher<Void, Never>
        let permissionDeniedResult: AnyPublisher<Void, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let notificationTokenUseCase: NotificationTokenUseCase
    
    init(notificationTokenUseCase: NotificationTokenUseCase) {
        self.notificationTokenUseCase = notificationTokenUseCase
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let notificationTapResult = input.notificationTap
            .handleEvents(receiveOutput:  { _ in
                AmplitudeManager.shared.trackEvent(AnalyticsEvent.SignUp.alarm)
            })
            .eraseToAnyPublisher()
        
        let showStudingTapResult = input.showStudingTap
            .handleEvents(receiveOutput:  { _ in
                AmplitudeManager.shared.trackEvent(AnalyticsEvent.SignUp.start)
            })
            .eraseToAnyPublisher()
        
        let permissionGrantedResult = input.permissionGrantedTap
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                guard let self else { return Just(()).eraseToAnyPublisher() }
                
                return Future { promise in
                    Task {
                        
                        let memberId = UserDefaults.standard.integer(forKey: "MemberId")
                        
                        let result = await self.saveNotificationToken(memberId)
                        switch result {
                        case .success:
                            promise(.success(()))
                        case .failure(let error):
                            print("Token 저장 실패: \(error)")
                            // 에러 처리 로직 추가 필요
                        }
                    }
                }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return Output(
            showStudingViewAction: showStudingTapResult,
            notificationTapAction: notificationTapResult,
            permissionGrantedResult: permissionGrantedResult,
            permissionDeniedResult: input.permissionDeniedTap
        )
    }
}

// MARK: - API methods extension

extension AuthWaitingViewModel {
    func saveNotificationToken(_ memberId: Int) async -> Result<Void, NetworkError> {
        switch await notificationTokenUseCase.execute(memberId: memberId) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
