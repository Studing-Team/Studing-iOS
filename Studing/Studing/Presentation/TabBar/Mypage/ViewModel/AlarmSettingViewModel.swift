//
//  AlarmSettingViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/22/25.
//

import Combine
import UserNotifications

final class AlarmSettingViewModel: BaseViewModel {
    
    // MARK: - Combine Publishers Properties
    
    var notificationStatusSubject = CurrentValueSubject<Bool, Never>(false)
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UseCase properties
    
    private let notificationTokenUseCase: NotificationTokenUseCase
    
    // MARK: - Input
    
    struct Input {
        let viewLifeCycleEventAction: AnyPublisher<ViewLifeCycleEvent, Never>
        let osSettingAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let viewLifeCycleEventResult: AnyPublisher<Bool, Never>
        let osSettingResult: AnyPublisher<Void, Never>
    }
    
    // MARK: - Init
        
    init(notificationTokenUseCase: NotificationTokenUseCase) {
        self.notificationTokenUseCase = notificationTokenUseCase
    }

    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        let viewLifeCycleEventResult = input.viewLifeCycleEventAction
            .flatMap { [weak self] _ in
                guard let self else {
                    return Just(false).eraseToAnyPublisher()
                }
                
                return self.checkNotificationStatus()
                    .handleEvents(receiveOutput: { isEnabled in
                        if isEnabled {
                            Task {
                                _ = await self.saveNotificationToken()
                            }
                        }
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return Output(
            viewLifeCycleEventResult: viewLifeCycleEventResult,
            osSettingResult: input.osSettingAction
        )
    }
}

// MARK: - API methods extension

extension AlarmSettingViewModel {
    func saveNotificationToken() async -> Result<Void, NetworkError> {
        switch await notificationTokenUseCase.execute(
            memberId: UserDefaults.standard.integer(forKey: "MemberId")
        ) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}

// MARK: - methods Extension

private extension AlarmSettingViewModel {
    func checkNotificationStatus() -> AnyPublisher<Bool, Never> {
        return Future<Bool, Never> { promise in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                let isEnabled = (settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional)

                promise(.success(isEnabled))
            }
        }
        .eraseToAnyPublisher()
    }
}
