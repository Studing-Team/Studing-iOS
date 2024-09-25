//
//  UniversityInfoViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import Foundation
import Combine

protocol InputUniversityNameDelegate: AnyObject {
    func didSubmitUniversityName(_ name: String)
}

final class UniversityInfoViewModel: BaseViewModel {
    
    weak var delegate: InputUniversityNameDelegate?
    
    // MARK: - Input
    
    struct Input {
        let nextTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let majorInfoViewAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    
    func submitUniversityName(name: String) {
        // 학교 정보를 처리한 후 delegate에 전달
        delegate?.didSubmitUniversityName(name)
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        return Output(majorInfoViewAction: input.nextTap)
    }
}
