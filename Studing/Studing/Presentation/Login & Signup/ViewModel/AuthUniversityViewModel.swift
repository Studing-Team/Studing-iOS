//
//  AuthUniversityViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/15/24.
//

import Foundation
import Combine

final class AuthUniversityViewModel: BaseViewModel {
    
    weak var delegate: InputStudentInfoDelegate?
  
    // MARK: - Input
    
    struct Input {
        let studentCardTap: AnyPublisher<Void, Never>
        let selectedImageData: CurrentValueSubject<Data?, Never>
        let userName: CurrentValueSubject<String, Never>
        let allStudentId: CurrentValueSubject<String, Never>
        let nextTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let openImagePicker: AnyPublisher<Void, Never>
        let isSelectedImage: AnyPublisher<Bool, Never>
        let isNextButtonEnabled: AnyPublisher<Bool, Never>
        let authUniversityViewAction: AnyPublisher<Void, Never>
    }
    
    // MARK: - Private propertiesdd
    
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

        let isNextButtonEnabled = Publishers.CombineLatest3(isSelectedImage, userNameState, allStudentIdState)
            .map { imageData, userName, allStudentId in
                imageData && userName && allStudentId
            }
            .eraseToAnyPublisher()
        
        let nextButtonTap = input.nextTap
            .map { [weak self] _ in
                guard let imageData = input.selectedImageData.value else { return }
                
                self?.delegate?.didSubmitStudentCardImage(imageData)
                self?.delegate?.didSubmitUserName(input.userName.value)
                self?.delegate?.didSubmitStudentNumber(input.allStudentId.value)
            }
            .eraseToAnyPublisher()
       
        return Output(
            openImagePicker: openImagePicker,
            isSelectedImage: isSelectedImage,
            isNextButtonEnabled: isNextButtonEnabled,
            authUniversityViewAction: nextButtonTap
        )
    }
}
