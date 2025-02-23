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
    
    private let bottomStackView = UIStackView()
    private let signUpButton = UIButton()
    private let divider = UIView()
    private let askStudingButton = UIButton()
    
    // MARK: - init
    
    init(
        viewModel: LoginViewModel,
        coordinator: LoginCoordinator
    ) {
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
            askTap: askStudingButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.isLoginButtonEnabled
            .map { $0 ? ButtonState.activate : ButtonState.deactivate }
            .assign(to: \.buttonState, on: loginButton)
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
                    self?.showConfirmAlert(
                        mainTitle: "잘못된 로그인 정보 입력",
                        subTitle: "입력한 아이디와 비밀번호가\n올바르지 않습니다.",
                        centerButtonStyle: .retry,
                        centerButtonHandler: {
                            AmplitudeManager.shared.trackEvent(AnalyticsEvent.Login.askStuding)
                            self?.dismiss(animated: false)
                    })
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
            $0.attributedPlaceholder = NSAttributedString(string: "아이디", attributes: [.foregroundColor: UIColor.white])
            $0.font = .interBody1()
            $0.backgroundColor = .white.withAlphaComponent(0.1)
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            $0.leftViewMode = .always
            $0.rightViewMode = .always
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.black5.cgColor
            $0.layer.cornerRadius = 10
        }
        
        userPwTextField.do {
            $0.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [.foregroundColor: UIColor.white])
            $0.isSecureTextEntry = true
            $0.font = .interBody1()
            $0.backgroundColor = .white.withAlphaComponent(0.1)
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            $0.leftViewMode = .always
            $0.rightViewMode = .always
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.black5.cgColor
            $0.layer.cornerRadius = 10
        }

        bottomStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillProportionally
            $0.spacing = 15
            $0.addArrangedSubviews(signUpButton, divider, askStudingButton)
        }
        
        signUpButton.do {
            let attributedString = NSAttributedString(string: "회원가입", attributes: [
                .font: UIFont.interBody2(),
                .foregroundColor: UIColor.white
            ])
            $0.setAttributedTitle(attributedString, for: .normal)
        }
        
        divider.do {
            $0.backgroundColor = .white
        }

        askStudingButton.do {
            let attributedString = NSAttributedString(string: "스튜딩 문의하기", attributes: [
                .font: UIFont.interBody2(),
                .foregroundColor: UIColor.white
            ])
            $0.setAttributedTitle(attributedString, for: .normal)
            
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(
            studingTitleLabel,
            userIdTextField,
            userPwTextField,
            loginButton,
            bottomStackView
        )
    }
    
    func setupLayout() {
        studingTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.convertByHeightRatio(219))
            $0.centerX.equalToSuperview()
        }
      
        userIdTextField.snp.makeConstraints {
            $0.top.equalTo(studingTitleLabel.snp.bottom).offset(view.convertByHeightRatio(115))
            $0.leading.equalToSuperview().offset(38)
            $0.trailing.equalToSuperview().inset(37)
            $0.height.equalTo(48)
        }
        
        userPwTextField.snp.makeConstraints {
            $0.top.equalTo(userIdTextField.snp.bottom).offset(view.convertByHeightRatio(7))
            $0.leading.equalToSuperview().offset(38)
            $0.trailing.equalToSuperview().inset(37)
            $0.height.equalTo(48)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(userPwTextField.snp.bottom).offset(view.convertByHeightRatio(7))
            $0.leading.equalToSuperview().offset(38)
            $0.trailing.equalToSuperview().inset(37)
            $0.height.equalTo(48)
        }
    
        bottomStackView.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(view.convertByHeightRatio(20))
            $0.centerX.equalToSuperview()
        }
        
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(52)
        }
        
        divider.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(14)
        }
 
        askStudingButton.snp.makeConstraints {
            $0.width.equalTo(95)
        }
    }
    
    func setupDelegate() {
        
    }
}
