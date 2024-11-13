//
//  UserInfoSignUpViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import Foundation
import Combine
import Alamofire

final class UserInfoSignUpViewModel: BaseViewModel {
    
    // MARK: - Combine Properties
    
    private let userIdStateSubject = CurrentValueSubject<TextFieldState, Never>(.normal(type: .userId))
    private let userPwStateSubject = CurrentValueSubject<TextFieldState, Never>(.normal(type: .userPw))
    private let confirmPwStateSubject = CurrentValueSubject<TextFieldState, Never>(.normal(type: .confirmPw))
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private let checkDuplicateIdUseCase: CheckDuplicateIdUseCase
    weak var delegate: InputUserInfoDelegate?

    // MARK: - init
    
    init(checkDuplicateIdUseCase: CheckDuplicateIdUseCase) {
        self.checkDuplicateIdUseCase = checkDuplicateIdUseCase
    }
    
    // MARK: - Input
    
    struct Input {
        let userId: CurrentValueSubject<String, Never>
        let userPw: CurrentValueSubject<String, Never>
        let confirmPw: AnyPublisher<String, Never>
        let duplicateIdTap: AnyPublisher<Void, Never>
        let nextTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let universityInfoViewAction: AnyPublisher<Void, Never>
        let isNextButtonEnabled: AnyPublisher<Bool, Never>
        let userIdState: AnyPublisher<TextFieldState, Never>
        let userPwState: AnyPublisher<TextFieldState, Never>
        let confirmPwState: AnyPublisher<TextFieldState, Never>
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        input.userId
            .map { [weak self] userId -> TextFieldState in
                // 유효성 검사 로직 추가
                if userId.isEmpty {
                    return .normal(type: .userId)
                } else {
                    return self?.validateUserId(userId) ?? .normal(type: .userId)
                }
            }
            .sink { [weak self] state in
                self?.userIdStateSubject.send(state)
            }
            .store(in: &cancellables)
        
        input.userPw
            .map { [weak self] userPw -> TextFieldState in
                // 여기에 userPw 유효성 검사 로직을 추가할 수 있습니다.
                if userPw.isEmpty {
                    .normal(type: .userPw)
                } else {
                    self?.validateUserPw(userPw) ?? .normal(type: .userPw)
                }
            }
            .sink { [weak self] state in
                self?.userPwStateSubject.send(state)
            }
            .store(in: &cancellables)

        Publishers.CombineLatest(input.userPw, input.confirmPw)
            .map { [weak self] userPw, confirmPw -> TextFieldState in
                //  return userPw == confirmPw && !userPw.isEmpty
                
                if confirmPw.isEmpty {
                    .normal(type: .confirmPw)
                } else {
                    self?.validateConfirmPw(userPw, confirmPw) ?? .normal(type: .confirmPw)
                }
            }
            .sink { [weak self] state in
                self?.confirmPwStateSubject.send(state)
            }
            .store(in: &cancellables)
        
        input.duplicateIdTap
            .flatMap { [weak self] _ -> AnyPublisher<TextFieldState, Never> in
                guard let self = self else {
                    return Just(.normal(type: .userId)).eraseToAnyPublisher()
                }
                
                return Future { promise in
                    Task {
                        let state = await self.checkDuplicatedId(userName: input.userId.value)
                        promise(.success(state))
                    }
                }.eraseToAnyPublisher()
            }
            .sink { [weak self] state in
                self?.userIdStateSubject.send(state)
            }
            .store(in: &cancellables)


        let isNextButtonEnabled = Publishers.CombineLatest3(userIdStateSubject, userPwStateSubject, confirmPwStateSubject)
            .map { userIdState, userPwState, confirmPwState in
                if case .success = userIdState,
                   case .success = userPwState,
                   case .success = confirmPwState {
                    return true
                } else {
                    return false
                }
            }
            .prepend(false)
            .eraseToAnyPublisher()
        
        let nextButtonTap = input.nextTap
            .map { [weak self] _ in
                self?.delegate?.didSubmitUserId(input.userId.value)
                self?.delegate?.didSubmitPassword(input.userPw.value)
            }
            .eraseToAnyPublisher()
        
        return Output(
            universityInfoViewAction: nextButtonTap,
            isNextButtonEnabled: isNextButtonEnabled,
            userIdState: userIdStateSubject.eraseToAnyPublisher(),
            userPwState: userPwStateSubject.eraseToAnyPublisher(),
            confirmPwState: confirmPwStateSubject.eraseToAnyPublisher()
        )
    }
}

private extension UserInfoSignUpViewModel {
    func validateUserId(_ userId: String) -> TextFieldState {
        if userId.count >= 6 && userId.count <= 12 && userId.rangeOfCharacter(from: .alphanumerics) != nil {
            return .validSuccess(type: .userId)
        } else {
            return .invalid(type: .userId)
        }
    }
    
    func validateUserPw(_ userPw: String) -> TextFieldState {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,16}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        if passwordTest.evaluate(with: userPw) {
            return .success(type: .userPw)
        } else {
            return .invalid(type: .userPw)
        }
    }
    
    func validateConfirmPw(_ userPw: String, _ confirmPw: String) -> TextFieldState {
        if userPw == confirmPw && !userPw.isEmpty {
            return .success(type: .confirmPw)
        } else {
            return .invalid(type: .confirmPw)
        }
    }
    
    func checkDuplicatedId(userName: String) async -> TextFieldState {
        switch await checkDuplicateIdUseCase.execute(userId: userName) {
        case .success:
            return .success(type: .userId)
        case .failure:
            return .duplicate(type: .userId)
        }
    }
}
