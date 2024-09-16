//
//  SignUpCoordinator.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import UIKit

final class SignUpCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: LoginCoordinator?
    
    var universityName: String?
    var majorName: String?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let userInfoSignUpVM = UserInfoSignUpViewModel()
        
        let signUpVC = UserInfoSignUpViewController(viewModel: userInfoSignUpVM, coordinator: self)
        navigationController.pushViewController(signUpVC, animated: true)
    }

    func pushUnivsersityInfoView() {
        let universityInfoVM = UniversityInfoViewModel()
        universityInfoVM.delegate = self
        
        let universityInfoVC = UniversityInfoViewController(viewModel: universityInfoVM, coordinator: self)
        navigationController.pushViewController(universityInfoVC, animated: true)
    }
    
    func pushMajorInfoView() {
        let majorInfoVC = MajorInfoViewController()
        navigationController.pushViewController(majorInfoVC, animated: true)
    }
    
    func pushTermsOfServiceView() {
        let termsOfServiceVC = TermsOfServiceViewController()
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
