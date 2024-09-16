//
//  AuthUniversityViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import UIKit

import SnapKit
import Then

final class AuthUniversityViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let authTitleLabel = UILabel()
    private let authSubTitleLabel = UILabel()
    private let emptyView = UIView()
    private let userNameTitleTextField = TitleTextFieldView(textFieldType: .userName)
    private let studentIdTitleTextField = TitleTextFieldView(textFieldType: .studentId)
    private let authenticationButton = UIButton()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Push AuthUniversityViewController")
        
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
            $0.text = StringLiterals.Authentication.universityTitle
        }
        
        authSubTitleLabel.do {
            $0.text = StringLiterals.Authentication.universitySubTitle
        }
        
        emptyView.do {
            $0.backgroundColor = .gray
        }
        
        authenticationButton.do {
            $0.setTitle(StringLiterals.Button.authTitle, for: .normal)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(authTitleLabel, authSubTitleLabel, emptyView, userNameTitleTextField, studentIdTitleTextField, authenticationButton)
    }
    
    func setupLayout() {
        authTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.convertByHeightRatio(29))
            $0.leading.equalToSuperview().offset(23)
        }
        
        authSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(authTitleLabel.snp.bottom).offset(view.convertByHeightRatio(18))
            $0.leading.equalToSuperview().offset(23)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(authSubTitleLabel.snp.bottom).offset(view.convertByHeightRatio(18))
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        userNameTitleTextField.snp.makeConstraints {
            $0.top.equalTo(emptyView.snp.bottom).offset(view.convertByHeightRatio(14))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        studentIdTitleTextField.snp.makeConstraints {
            $0.top.equalTo(userNameTitleTextField.snp.bottom).offset(view.convertByHeightRatio(17))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        authenticationButton.snp.makeConstraints {
            $0.top.equalTo(studentIdTitleTextField.snp.bottom).offset(view.convertByHeightRatio(59))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-31)
        }
    }
    
    func setupDelegate() {
        
    }
}
