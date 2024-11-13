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
    }
    
    // MARK: - Output
    
    struct Output {
        let showStudingViewAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let signupUseCase: SignupUseCase
    private let signupData: SignupRequestDTO?
    
    init(signupUseCase: SignupUseCase,
         signupData: SignupRequestDTO?) {
        self.signupUseCase = signupUseCase
        self.signupData = signupData
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        Task {
            await sigupUser()
        }

        return Output(
            showStudingViewAction: input.showStudingTap
        )
    }
}

extension AuthWaitingViewModel {
    func sigupUser() async {
        
        guard let signupData else { return }
        
        switch await signupUseCase.execute(request: signupData) {
        case .success(let success):
            print("성공")
        case .failure(let failure):
            print("실패")
        }
    }
}
