//
//  UserInfoSignUpViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/15/24.
//

import UIKit
import Combine

import SnapKit
import Then

final class UserInfoSignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: UserInfoSignUpViewModel
    weak var coordinator: SignUpCoordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let stepCountView = StepCountView(count: 1)
    private let titleLabel = UILabel()
    private let duplicateIdButton = UIButton()
    private let userIdTitleTextField = TitleTextFieldView(textFieldType: .userId)
    private let userPwTextField = TitleTextFieldView(textFieldType: .userPw)
    private let comfirmPwTitleTextField = TitleTextFieldView(textFieldType: .confirmPw)
    private let nextButton = CustomButton(buttonStyle: .next)
    
    // MARK: - init
    
    init(viewModel: UserInfoSignUpViewModel,
         coordinator: SignUpCoordinator) {
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
        
        print("Push UserInfoSignUpViewController")
        view.backgroundColor = .signupBackground
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("Pop UserInfoSignUpViewController")
    }
}

// MARK: - Private Bind Extensions

private extension UserInfoSignUpViewController {
    func bindViewModel() {
        
        let input = UserInfoSignUpViewModel.Input(
            userId: userIdTitleTextField.textPublisher.eraseToAnyPublisher(),
            userPw: userPwTextField.textPublisher.eraseToAnyPublisher(),
            confirmPw: comfirmPwTitleTextField.textPublisher.eraseToAnyPublisher(),
            nextTap: nextButton.tapPublisher)
        
        let output = viewModel.transform(input: input)
        
        /// 다음 버튼이 눌릴 수 있는지
        output.isNextButtonEnabled
//            .map { $0 ? ButtonState.activate : ButtonState.deactivate }
            .map { _ in .activate }
            .assign(to: \.buttonState, on: nextButton)
            .store(in: &cancellables)
        
        /// userIdTextField 의 State
        output.userIdState
            .sink { [weak self] state in
                self?.userIdTitleTextField.setState(state)
                
                switch state {
                case .normal, .invalid, .duplicate, .select:
                    self?.duplicateIdButton.backgroundColor = .black30
                case .success:
                    self?.duplicateIdButton.backgroundColor = .primary50
                }
            }
            .store(in: &cancellables)
        
        /// userPwTextField 의 State
        output.userPwState
            .sink { [weak self] state in
                self?.userPwTextField.setState(state)
            }
            .store(in: &cancellables)
        
        /// comfirmPwTextField 의 State
        output.confirmPwState
            .sink { [weak self] state in
                self?.comfirmPwTitleTextField.setState(state)
            }
            .store(in: &cancellables)
        
        /// UniversityInfoView 로 화면 전환
        output.universityInfoViewAction
            .sink { [weak self] _ in
                self?.coordinator?.pushUnivsersityInfoView()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension UserInfoSignUpViewController {
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupStyle() {
        titleLabel.do {
            $0.text = StringLiterals.Title.authUserInfo
            $0.font = .interHeadline2()
            $0.textColor = .black50
        }
        
        duplicateIdButton.do {
            $0.setAttributedTitle(NSAttributedString(string: "중복확인", attributes: .init([.font: UIFont.interBody2()])), for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .black30
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(stepCountView, titleLabel, userIdTitleTextField, duplicateIdButton, userPwTextField, comfirmPwTitleTextField, nextButton)
    }
    
    func setupLayout() {
        stepCountView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(20))
            $0.leading.equalToSuperview().offset(19)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stepCountView.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.leading.equalToSuperview().offset(19)
        }
        
        userIdTitleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(view.convertByHeightRatio(30))
            $0.leading.equalToSuperview().offset(19)
        }
        
        duplicateIdButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(view.convertByHeightRatio(58))
            $0.leading.equalTo(userIdTitleTextField.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(22)
            $0.width.equalTo(69)
            $0.height.equalTo(38)
        }
        
        userPwTextField.snp.makeConstraints {
            $0.top.equalTo(userIdTitleTextField.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.horizontalEdges.equalToSuperview().inset(19)
        }
        
        comfirmPwTitleTextField.snp.makeConstraints {
            $0.top.equalTo(userPwTextField.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.horizontalEdges.equalToSuperview().inset(19)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            $0.height.equalTo(48)
        }
    }
    
    func setupDelegate() {
        
    }
}
