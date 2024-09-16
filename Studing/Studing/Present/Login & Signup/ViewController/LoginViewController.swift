//
//  ViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 8/31/24.
//

import UIKit
import Combine

import SnapKit
import Then

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: LoginViewModel
    weak var coordinator: LoginCoordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let logoImage = UIImageView()
    private let userIdTextField = UITextField()
    private let userPwTextField = UITextField()
    private let loginButton = UIButton()
    private let signUpButton = UIButton()
    private let kakaoButton = UIButton()
    
    // MARK: - init
    
    init(viewModel: LoginViewModel, coordinator: LoginCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Push LoginViewController")
        
        view.backgroundColor = .white
        hideKeyboard()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
    }
}

// MARK: - Private Bind Extensions

private extension LoginViewController {
    func bindViewModel() {
        let input = LoginViewModel.Input(
            username: userIdTextField.textPublisher,
            password: userPwTextField.textPublisher,
            signUpTap: signUpButton.tapPublisher,
            loginTap: loginButton.tapPublisher,
            kakaoTap: kakaoButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.isLoginButtonEnabled
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)
        
        output.signUpAction
            .sink { [weak self] _ in
                self?.coordinator?.showSignUp()
            }
            .store(in: &cancellables)
            
        
        output.loginResult
            .sink { [weak self] result in
                switch result {
                case .success(let user):
                    self?.coordinator?.login()
                case .failure(let error):
//                    self?.showError(error)
                    break
                }
            }
            .store(in: &cancellables)
    }
}


// MARK: - Private Layout Extensions

private extension LoginViewController {
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupStyle() {
        logoImage.do {
            $0.backgroundColor = .black
        }
        
        userIdTextField.do {
            $0.placeholder = "아이디"
        }
        
        userPwTextField.do {
            $0.placeholder = "비밀번호"
        }
        
        loginButton.do {
            $0.setTitle("로그인", for: .normal)
            $0.backgroundColor = .black
            $0.tintColor = .black
        }
        
        signUpButton.do {
            $0.setTitle("회원가입", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
        
        kakaoButton.do {
            $0.setTitle("카카오톡 문의하기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(logoImage, userIdTextField, userPwTextField, loginButton, signUpButton, kakaoButton)
    }
    
    func setupLayout() {
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.convertByHeightRatio(121))
            $0.horizontalEdges.equalToSuperview().inset(116)
            $0.height.equalTo(142)
        }
      
        userIdTextField.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(view.convertByHeightRatio(48))
            $0.horizontalEdges.equalToSuperview().inset(36)
            $0.height.equalTo(42)
        }
        
        userPwTextField.snp.makeConstraints {
            $0.top.equalTo(userIdTextField.snp.bottom).offset(view.convertByHeightRatio(11))
            $0.horizontalEdges.equalToSuperview().inset(36)
            $0.height.equalTo(42)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(userPwTextField.snp.bottom).offset(view.convertByHeightRatio(11))
            $0.horizontalEdges.equalToSuperview().inset(36)
            $0.height.equalTo(42)
        }

        signUpButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(view.convertByHeightRatio(31))
            $0.horizontalEdges.equalToSuperview().inset(160)
        }

        kakaoButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(110)
            $0.bottom.equalToSuperview().offset(view.convertByHeightRatio(-37))
        }
    }
    
    func setupDelegate() {
        
    }
}
