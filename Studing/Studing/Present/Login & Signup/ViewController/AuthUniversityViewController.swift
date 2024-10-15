//
//  AuthUniversityViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class AuthUniversityViewController: UIViewController {

    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let stepCountView = StepCountView(count: 6)
    private let authTitleLabel = UILabel()
    private let authSubTitleLabel = UILabel()
    
    private let uploadBackgroundView = DashedLineBorderView()
    private let uploadImageView = UIImageView()
    private let uploadStudentCardTitle = UILabel()
    private let studentCardButton = CustomButton(buttonStyle: .studentCard)
    private let userNameTitleTextField = TitleTextFieldView(textFieldType: .userName)
    private let studentIdTitleTextField = TitleTextFieldView(textFieldType: .allStudentId)
    private let authenticationButton = CustomButton(buttonStyle: .next)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Push AuthUniversityViewController")
        view.backgroundColor = .signupBackground
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Pop AuthUniversityViewController")
    }
}

// MARK: - Private Extensions

private extension AuthUniversityViewController {
    func setNavigationBar() {
        self.navigationItem.title = StringLiterals.NavigationTitle.authUniversity
        self.navigationItem.largeTitleDisplayMode = .inline
    }
    
    func setupStyle() {
        authTitleLabel.do {
            $0.text = StringLiterals.Title.authUniversityStudent
            $0.font = .interHeadline3()
            $0.textColor = .black50
            $0.numberOfLines = 2
        }
        
        authSubTitleLabel.do {
            $0.text = StringLiterals.Authentication.universitySubTitle
            $0.font = .interBody3()
            $0.textColor = .black40
            $0.numberOfLines = 2
        }
        
        uploadBackgroundView.do {
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .white
            $0.clipsToBounds = true
        }
        
        uploadImageView.do {
            $0.image = UIImage(named: "uploadImage")
        }
        
        uploadStudentCardTitle.do {
            $0.text = StringLiterals.Authentication.studentCardTitle
            $0.font = .interCaption12()
            $0.textColor = .black40
        }
        
        authenticationButton.do {
            $0.setTitle(StringLiterals.Button.authTitle, for: .normal)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(stepCountView, authTitleLabel, authSubTitleLabel, uploadBackgroundView, userNameTitleTextField, studentIdTitleTextField, authenticationButton)
        
        uploadBackgroundView.addSubviews(uploadImageView, uploadStudentCardTitle, studentCardButton)
    }
    
    func setupLayout() {
        stepCountView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(20))
            $0.leading.equalToSuperview().offset(19)
        }
        
        authTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stepCountView.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.leading.equalToSuperview().offset(23)
            $0.trailing.equalToSuperview().inset(132)
        }
        
        authSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(authTitleLabel.snp.bottom).offset(view.convertByHeightRatio(10))
            $0.leading.equalToSuperview().offset(23)
        }
        
        uploadBackgroundView.snp.makeConstraints {
            $0.top.equalTo(authSubTitleLabel.snp.bottom).offset(view.convertByHeightRatio(36))
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        userNameTitleTextField.snp.makeConstraints {
            $0.top.equalTo(uploadBackgroundView.snp.bottom).offset(view.convertByHeightRatio(40))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        studentIdTitleTextField.snp.makeConstraints {
            $0.top.equalTo(userNameTitleTextField.snp.bottom).offset(view.convertByHeightRatio(20))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        authenticationButton.snp.makeConstraints {
            $0.top.equalTo(studentIdTitleTextField.snp.bottom).offset(view.convertByHeightRatio(40))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(48)
        }
        
        uploadImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(view.convertByWidthRatio(60))
            $0.height.equalTo(view.convertByHeightRatio(60))
        }
        
        uploadStudentCardTitle.snp.makeConstraints {
            $0.top.equalTo(uploadImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        studentCardButton.snp.makeConstraints {
            $0.top.equalTo(uploadStudentCardTitle.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-29)
            $0.width.equalTo(212)
            $0.height.equalTo(24)
        }
    }
    
    func setupDelegate() {
        
    }
}
