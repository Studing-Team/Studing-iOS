//
//  MajorInfoViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/25/24.
//

import Foundation
import Combine

final class MajorInfoViewModel: BaseViewModel {
    
    // MARK: - Input
    
    struct Input {
        let nextTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let TermsOfServiceViewAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        return Output(TermsOfServiceViewAction: input.nextTap)
    }
}
