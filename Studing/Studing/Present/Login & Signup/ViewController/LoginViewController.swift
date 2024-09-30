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
    
    private let studingTitleLabel = UILabel()
    private let userIdTextField = UITextField()
    private let userPwTextField = UITextField()
    private let loginButton = CustomButton(buttonStyle: .login)
    private let bottomMenuStackView = UIStackView()
    private let findMyIdButton = UIButton()
    private let findMyPwButton = UIButton()
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
        
        view.applyGradient(colors: [.loginStartGradient, .loginEndGradient], direction: .topRightToBottomLeft, locations: [-0.2, 1.3])
        
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
        studingTitleLabel.do {
            $0.text = "Studing"
            $0.textColor = .white
            $0.font = .montserratExtraBold(size: 34)
        }
        
        userIdTextField.do {
            $0.attributedPlaceholder = NSAttributedString(string: "아이디", attributes: [.foregroundColor: UIColor.black50])
            $0.font = .interBody1()
            $0.backgroundColor = .black10
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            $0.leftViewMode = .always
            $0.rightViewMode = .always
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.cornerRadius = 18
        }
        
        userPwTextField.do {
            $0.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [.foregroundColor: UIColor.black50])
            $0.font = .interBody1()
            $0.backgroundColor = .black10
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            $0.leftViewMode = .always
            $0.rightViewMode = .always
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.cornerRadius = 18
        }
        
        bottomMenuStackView.do {
            $0.addArrangedSubviews(findMyIdButton, createDivider(), findMyPwButton, createDivider(), signUpButton)
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .equalSpacing
            $0.spacing = 15
        }
        
        findMyIdButton.do {
            $0.setTitle("아이디 찾기", for: .normal)
            $0.titleLabel?.font = .interBody2()
            $0.setTitleColor(.black, for: .normal)
        }
        
        findMyPwButton.do {
            $0.setTitle("비밀번호 찾기", for: .normal)
            $0.titleLabel?.font = .interBody2()
            $0.setTitleColor(.black, for: .normal)
        }
        
        signUpButton.do {
            $0.setTitle("회원가입", for: .normal)
            $0.titleLabel?.font = .interBody2()
            $0.setTitleColor(.black, for: .normal)
        }
        
        kakaoButton.do {
            $0.setImage(UIImage.kakaoTalkIcon, for: .normal)
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(studingTitleLabel, userIdTextField, userPwTextField, loginButton, bottomMenuStackView, kakaoButton)
    }
    
    func setupLayout() {
        studingTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.convertByHeightRatio(219))
            $0.centerX.equalToSuperview()
        }
      
        userIdTextField.snp.makeConstraints {
            $0.top.equalTo(studingTitleLabel.snp.bottom).offset(view.convertByHeightRatio(80))
            $0.horizontalEdges.equalToSuperview().inset(36)
            $0.height.equalTo(36)
        }
        
        userPwTextField.snp.makeConstraints {
            $0.top.equalTo(userIdTextField.snp.bottom).offset(view.convertByHeightRatio(11))
            $0.horizontalEdges.equalToSuperview().inset(36)
            $0.height.equalTo(36)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(userPwTextField.snp.bottom).offset(view.convertByHeightRatio(11))
            $0.horizontalEdges.equalToSuperview().inset(36)
            $0.height.equalTo(36)
        }
        
        bottomMenuStackView.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(view.convertByHeightRatio(25))
            $0.horizontalEdges.equalToSuperview().inset(56)
        }

        kakaoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(view.convertByHeightRatio(-20))
            $0.width.height.equalTo(49)
        }
    }
    
    func setupDelegate() {
        
    }
    
    // Divider를 생성하는 함수
    func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .black40 // Divider 색상 설정
        
        divider.snp.makeConstraints {
            $0.width.equalTo(1) // Divider의 너비를 설정
            $0.height.equalTo(14)
        }
        
        return divider
    }
}
