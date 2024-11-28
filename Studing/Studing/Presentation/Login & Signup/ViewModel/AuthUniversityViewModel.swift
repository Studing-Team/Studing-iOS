//
//  AuthUniversityViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/15/24.
//

import Foundation
import Combine

enum AuthUniversityType {
    case signup
    case reSubmit
}

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
    
    var authType: AuthUniversityType
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UseCase properties
    
    private var signupUseCase: SignupUseCase? = nil
    private var signupUserInfo: SignupUserInfo? = nil
    private var resubmitUseCase: ReSubmitUseCase? = nil
    
    // MARK: - init
    
    init(signupUseCase: SignupUseCase,
         signupUserInfo: SignupUserInfo?,
         authType: AuthUniversityType
    ) {
        self.signupUseCase = signupUseCase
        self.signupUserInfo = signupUserInfo
        self.authType = authType
    }
    
    init(resubmitUseCase: ReSubmitUseCase,
         authType: AuthUniversityType) {
        self.resubmitUseCase = resubmitUseCase
        self.authType = authType
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        
        let allStudentIdState = input.allStudentId
            .map { input in
                input.isEmpty ? false : true
            }
            .eraseToAnyPublisher()

        let isNextButtonEnabled = Publishers.CombineLatest3(isSelectedImage, userNameState, allStudentIdState)
            .map { imageData, userName, allStudentId in
                return imageData && userName && allStudentId
            }
            .eraseToAnyPublisher()
        
        let nextButtonTap = input.nextTap
            .flatMap { [weak self] _ -> AnyPublisher<Bool, Never> in
                guard let self else { return Just((false)).eraseToAnyPublisher() }
                guard let imageData = input.selectedImageData.value else { return Just((false)).eraseToAnyPublisher() }
                
                return Future { promise in
                    Task {
                        switch self.authType {
                        case .signup:
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
                            
                        case .reSubmit:
                            let result = await self.reSubmit(
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
        guard let signupUseCase else { return .failure(.clientError(message: "다시 시도하세요.")) }
        
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
    
    func reSubmit(userName: String, studentNumber: String, image: Data) async -> Result<Void, NetworkError> {
        guard let resubmitUseCase else { return .failure(.clientError(message: "다시 시도하세요.")) }
        
        let requestDTO = ReSubmitRequestDTO(
            admissionNumber: studentNumber,
            name: userName,
            studentCardImage: image
        )
        
        switch await resubmitUseCase.execute(dto: requestDTO) {
        case .success:
            KeychainManager.shared.saveData(key: .userAuthState, value: UserAuth.unUser.rawValue)
            
            NotificationCenter.default.post(
                            name: .userAuthDidUpdate,
                            object: nil,
                            userInfo: ["userAuth": UserAuth.unUser] // 필요한 데이터를 dictionary로 전달
                        )
            
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
