//
//  SignUpCoordinator.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import UIKit

protocol SignUpCoordinatorDelegate: AnyObject {
    func didSignUpFinishFlow(_ coordinator: SignUpCoordinator)
}

final class SignUpCoordinator: Coordinator {
    var navigationController: CustomSignUpNavigationController
    var childCoordinators: [any Coordinator] = []
    
    weak var parentCoordinator: LoginCoordinator?
    weak var delegate: SignUpCoordinatorDelegate?

    private let signUpStore: SignUpStore
    
    init(navigationController: CustomSignUpNavigationController) {
        self.navigationController = navigationController
        self.navigationController.interactivePopGestureRecognizer?.isEnabled = false
        
        self.signUpStore = SignUpStore()
    }
    
    func start() {
        let userInfoSignUpVM = UserInfoSignUpViewModel(checkDuplicateIdUseCase: CheckDuplicateIdUseCase(repository: MemberRepositoryImpl()))
        
        userInfoSignUpVM.delegate = self
        
        let signUpVC = UserInfoSignUpViewController(viewModel: userInfoSignUpVM, coordinator: self)

        navigationController.changeSignUpStep(count: 1)
        navigationController.pushViewController(signUpVC, animated: true)
    }

    func pushUnivsersityInfoView() {
        let universityInfoVM = UniversityInfoViewModel(universityListUseCase: UniversityListUseCase(repository: UniversityDataRepositoryImpl()))
        
        universityInfoVM.delegate = self
        
        let universityInfoVC = UniversityInfoViewController(viewModel: universityInfoVM, coordinator: self)
        
        navigationController.changeSignUpStep(count: 2)
        navigationController.pushViewController(universityInfoVC, animated: true)
    }
    
    func pushMajorInfoView() {
        let majorInfoVM = MajorInfoViewModel(universityName: signUpStore.university ?? "", departmentListUseCase: DepartmentListUseCase(repository: UniversityDataRepositoryImpl()))
        
        majorInfoVM.delegate = self
        
        let majorInfoVC = MajorInfoViewController(viewModel: majorInfoVM, coordinator: self)
        
        navigationController.changeSignUpStep(count: 3)
        navigationController.pushViewController(majorInfoVC, animated: true)
    }
    
    func pushStudentIdView() {
        let studentIdVM = StudentIdViewModel()
        
        studentIdVM.delegate = self
        
        let studentIdVC = StudentIdViewController(viewModel: studentIdVM, coordinator: self)
        
        navigationController.changeSignUpStep(count: 4)
        navigationController.pushViewController(studentIdVC, animated: true)
    }
    
    func pushTermsOfServiceView() {
        let termsOfServiceVM = TermsOfServiceViewModel()
        
        termsOfServiceVM.delegate = self
        
        let termsOfServiceVC = TermsOfServiceViewController(viewModel: termsOfServiceVM, coordinator: self)
        
        navigationController.changeSignUpStep(count: 5)
        navigationController.pushViewController(termsOfServiceVC, animated: true)
    }
    
    func pushAuthUniversityView() {
        let authUniversityVM = AuthUniversityViewModel(
            signupUseCase: SignupUseCase(repository: MemberRepositoryImpl()), 
            signupUserInfo: signUpStore.getUserData()
        )
        
//        authUniversityVM.delegate = self
        
        let authUniversityVC = AuthUniversityViewController(viewModel: authUniversityVM, coordinator: self)
        
        navigationController.changeSignUpStep(count: 6)
        navigationController.pushViewController(authUniversityVC, animated: true)
    }
    
    func pushAuthWaitingView() {
        let authWaitingVM = AuthWaitingViewModel(
            notificationTokenUseCase: NotificationTokenUseCase(repository: NotificationsRepositoryImpl())
        )
        
        let authUniversityVC = AuthWaitingViewController(viewModel: authWaitingVM, coordinator: self)
        
        navigationController.changeSignUpStep(count: 6)
        navigationController.pushViewController(authUniversityVC, animated: true)
    }
    
    func pushSuccessSignUpView() {
        let successSignUpVC = SuccessSignUpViewController(coordinator: self)
        navigationController.pushViewController(successSignUpVC, animated: true)
    }
    
    func finishSignUp() {
        delegate?.didSignUpFinishFlow(self)
    }
}

// MARK: - Input Delegate

extension SignUpCoordinator: InputUserInfoDelegate {
    func didSubmitUserId(_ userId: String) {
        signUpStore.setUserId(userId)
    }
    
    func didSubmitPassword(_ password: String) {
        signUpStore.setPassword(password)
    }
}


extension SignUpCoordinator: InputUniversityNameDelegate {
    func didSubmitUniversityName(_ name: String) {
        signUpStore.setUniversity(name)
    }
}

extension SignUpCoordinator: InputMajorDelegate {
    func didSubmitMajor(_ major: String) {
        signUpStore.setMajor(major)
    }
}

extension SignUpCoordinator: InputAdmissionDelegate {
    func didSubmitAdmission(_ admission: String) {
        signUpStore.setAdmission(admission)
    }
}

extension SignUpCoordinator: InputmarketingDelegate {
    func didSubmitMarketing(_ isMarketing: Bool) {
        signUpStore.setMarketing(isMarketing)
    }
}

//extension SignUpCoordinator: InputStudentInfoDelegate {
//    func didSubmitStudentCardImage(_ imageData: Data) {
//        signUpStore.setStudentCardImage(imageData)
//    }
//    
//    func didSubmitUserName(_ userName: String) {
//        signUpStore.setUserName(userName)
//    }
//    
//    func didSubmitStudentNumber(_ studentNumber: String) {
//        signUpStore.setStudentNumber(studentNumber)
//    }
//}
