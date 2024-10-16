//
//  AuthUniversityViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/15/24.
//

import Foundation
import Combine

final class AuthUniversityViewModel: BaseViewModel {
  
    // MARK: - Input
    
    struct Input {
        let studentCardTap: AnyPublisher<Void, Never>
        let selectedImageData: AnyPublisher<Data?, Never>
        let userName: AnyPublisher<String, Never>
        let allStudentId: AnyPublisher<String, Never>
        let nextTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let openImagePicker: AnyPublisher<Void, Never>
        let isSelectedImage: AnyPublisher<Bool, Never>
        let isNextButtonEnabled: AnyPublisher<Bool, Never>
        let authUniversityViewAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        
        let openImagePicker = input.studentCardTap
            .eraseToAnyPublisher()
        
        let isSelectedImage = input.selectedImageData
            .map { data in
                data == nil ? false : true
            }
            .eraseToAnyPublisher()
        
        let userNameState = input.userName
            .map { input in
                return input.isEmpty ? false : true
            }
            .eraseToAnyPublisher()
        
        let allStudentIdState = input.userName
            .map { input in
                input.isEmpty ? false : true
            }
            .eraseToAnyPublisher()

        let nextButtonState = Publishers.CombineLatest(
            userNameState,
            allStudentIdState
        )

        let isNextButtonEnabled = nextButtonState
            .map { userName, allStudentId in
                userName && allStudentId
            }
            .eraseToAnyPublisher()

       
        return Output(
            openImagePicker: openImagePicker,
            isSelectedImage: isSelectedImage,
            isNextButtonEnabled: isNextButtonEnabled,
            authUniversityViewAction: input.nextTap
        )
    }
}
