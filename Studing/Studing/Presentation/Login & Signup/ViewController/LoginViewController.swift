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
    private let signUpButton = UIButton()
    private let indicateImageView = UIImageView()
    private let indicateTitleLabel = UILabel()
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
        
        setupKeyboardHandling()
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
            askTap: kakaoButton.tapPublisher
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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator?.login()
                case .failure:
                    self?.showConfirmAlert(mainTitle: "잘못된 로그인 정보 입력", subTitle: "입력한 아이디와 비밀번호가\n올바르지 않습니다.", confirmTitle: "다시 시도", centerButtonHandler: nil)
                }
            }
            .store(in: &cancellables)
        
        output.askButtonTap
            .receive(on: DispatchQueue.main)
            .sink { _ in
                guard let url = URL(string: StringLiterals.Web.askStuding),
                      UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url, options: [:])
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
            $0.font = .montserratAlternatesExtraBold(size: 34)
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
            $0.isSecureTextEntry = true
            $0.font = .interBody1()
            $0.backgroundColor = .black10
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            $0.leftViewMode = .always
            $0.rightViewMode = .always
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.cornerRadius = 17
        }

        signUpButton.do {
            let attributedString = NSAttributedString(string: "회원가입", attributes: [
                .font: UIFont.interBody2(),
                .foregroundColor: UIColor.black50,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ])
            $0.setAttributedTitle(attributedString, for: .normal)
        }
        
        indicateImageView.do {
            $0.image = UIImage(named: "indicateImage")
            $0.clipsToBounds = true
        }
        
        indicateTitleLabel.do {
            $0.text = "스튜딩에 문의하기"
            $0.textColor = .black30
            $0.font = .interBody2()
        }
    
        kakaoButton.do {
            $0.setImage(UIImage.inquiry, for: .normal)
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(studingTitleLabel, userIdTextField, userPwTextField, loginButton, signUpButton, indicateImageView, kakaoButton)
        indicateImageView.addSubview(indicateTitleLabel)
    }
    
    func setupLayout() {
        studingTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.convertByHeightRatio(219))
            $0.centerX.equalToSuperview()
        }
      
        userIdTextField.snp.makeConstraints {
            $0.top.equalTo(studingTitleLabel.snp.bottom).offset(view.convertByHeightRatio(80))
            $0.leading.equalToSuperview().offset(38)
            $0.trailing.equalToSuperview().inset(37)
            $0.height.equalTo(34)
        }
        
        userPwTextField.snp.makeConstraints {
            $0.top.equalTo(userIdTextField.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.leading.equalToSuperview().offset(38)
            $0.trailing.equalToSuperview().inset(37)
            $0.height.equalTo(34)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(userPwTextField.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.leading.equalToSuperview().offset(38)
            $0.trailing.equalToSuperview().inset(37)
            $0.height.equalTo(36)
        }
    
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(view.convertByHeightRatio(20))
            $0.leading.equalToSuperview().offset(162)
            $0.trailing.equalToSuperview().inset(161)
            $0.height.equalTo(18)
        }

        indicateImageView.snp.makeConstraints {
            $0.top.equalTo(signUpButton.snp.bottom).offset(view.convertByHeightRatio(137))
            $0.centerX.equalToSuperview()
        }
        
        indicateTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-15)
        }

        kakaoButton.snp.makeConstraints {
            $0.top.equalTo(indicateImageView.snp.bottom).offset(10)
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
