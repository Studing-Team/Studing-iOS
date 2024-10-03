//
//  SignUpCoordinator.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import UIKit

final class SignUpCoordinator: Coordinator {
    var navigationController: CustomSignUpNavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: LoginCoordinator?
    
    var universityName: String?
    var majorName: String?
    
    init(navigationController: CustomSignUpNavigationController) {
        self.navigationController = navigationController
        self.navigationController.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func start() {
        let userInfoSignUpVM = UserInfoSignUpViewModel()
        
        let signUpVC = UserInfoSignUpViewController(viewModel: userInfoSignUpVM, coordinator: self)

        navigationController.changeSignUpStep(count: 1)
        navigationController.pushViewController(signUpVC, animated: true)
    }

    func pushUnivsersityInfoView() {
        let universityInfoVM = UniversityInfoViewModel()
        universityInfoVM.delegate = self
        
        let universityInfoVC = UniversityInfoViewController(viewModel: universityInfoVM, coordinator: self)
        
        navigationController.changeSignUpStep(count: 2)
        navigationController.pushViewController(universityInfoVC, animated: true)
    }
    
    func pushMajorInfoView() {
        let majorInfoVM = MajorInfoViewModel()
        let majorInfoVC = MajorInfoViewController(viewModel: majorInfoVM, coordinator: self)
        
        navigationController.changeSignUpStep(count: 3)
        navigationController.pushViewController(majorInfoVC, animated: true)
    }
    
    func pushStudentIdView() {
        let studentIdVM = StudentIdViewModel()
        let studentIdVC = StudentIdViewController(viewModel: studentIdVM, coordinator: self)
        
        navigationController.changeSignUpStep(count: 4)
        navigationController.pushViewController(studentIdVC, animated: true)
    }
    
    func pushTermsOfServiceView() {
        let termsOfServiceVC = TermsOfServiceViewController()
        
        navigationController.changeSignUpStep(count: 5)
        navigationController.pushViewController(termsOfServiceVC, animated: true)
    }
    
    func pushAuthUniversityView() {
        let authUniversityVC = AuthUniversityViewController()
        navigationController.pushViewController(authUniversityVC, animated: true)
    }
    
    func pushSuccessSignUpView() {
        let successSignUpVC = SuccessSignUpViewController()
        navigationController.pushViewController(successSignUpVC, animated: true)
    }
}

extension SignUpCoordinator: InputUniversityNameDelegate {
    func didSubmitUniversityName(_ name: String) {
        self.universityName = name
    }
}
