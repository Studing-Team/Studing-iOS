//
//  AuthUniversityViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/15/24.
//

import Foundation
import Combine

final class AuthUniversityViewModel: BaseViewModel {
    
//    weak var delegate: InputStudentInfoDelegate?
  
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
        let authUniversityViewAction: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Private properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UseCase properties
    
    private let signupUseCase: SignupUseCase
    private let signupUserInfo: SignupUserInfo?
    
    // MARK: - init
    
    init(signupUseCase: SignupUseCase,
         signupUserInfo: SignupUserInfo?
    ) {
        self.signupUseCase = signupUseCase
        self.signupUserInfo = signupUserInfo
    }
    
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
            .flatMap { [weak self] _ -> AnyPublisher<Bool, Never> in
                guard let self else { return Just((false)).eraseToAnyPublisher() }
                guard let imageData = input.selectedImageData.value else { return Just((false)).eraseToAnyPublisher() }
                
                return Future { promise in
                    Task {
                        let result = await self.signupUser(
                            userName: input.userName.value,
                            studentNumber: input.allStudentId.value,
                            image: imageData
                        )
                        
                        switch result {
                        case .success:
                            promise(.success(true))
                        case .failure(let error):
                            promise(.success(false))
                        }
                    }
                }
                .eraseToAnyPublisher()
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

// MARK: - API methods extension

extension AuthUniversityViewModel {
    func signupUser(userName: String, studentNumber: String, image: Data) async -> Result<Void, NetworkError> {
        
        guard let signupUserInfo else { return .failure(.clientError(message: "유저데이터 없음")) }
        
        let requestDTO = convertToSignupRequestDTO(
            signupUserInfo: signupUserInfo,
            userName: userName,
            studentNumber: studentNumber,
            image: image
        )
        
        switch await signupUseCase.execute(request: requestDTO) {
        case .success(let response):
            UserDefaults.standard.set(response.memberId, forKey: "MemberId")
            return .success(())
        case .failure(let error):
            print("Error:", error.localizedDescription)
            return .failure(error)
        }
    }
}

// MARK: - private extension

extension AuthUniversityViewModel {
    func convertToSignupRequestDTO(signupUserInfo: SignupUserInfo, userName: String, studentNumber: String, image: Data) -> SignupRequestDTO {
        
        return SignupRequestDTO(
            loginIdentifier: signupUserInfo.userId,
            password: signupUserInfo.password,
            admissionNumber: signupUserInfo.admission,
            studentNumber: studentNumber,
            name: userName,
            memberUniversity: signupUserInfo.university,
            memberDepartment: signupUserInfo.major,
            studentCardImage: image,
            marketingAgreement: signupUserInfo.marketing
        )
    }
}
