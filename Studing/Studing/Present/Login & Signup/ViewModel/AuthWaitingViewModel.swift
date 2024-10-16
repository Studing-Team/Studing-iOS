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
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {

        return Output(
            showStudingViewAction: input.showStudingTap
        )
    }
}
