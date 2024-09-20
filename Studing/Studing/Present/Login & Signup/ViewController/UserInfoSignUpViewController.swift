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
    
    private let titleLabel = UILabel()
    private let duplicateIdButton = UIButton()
    private let userIdTitleTextField = TitleTextFieldView(textFieldType: .userId)
    private let userPwTextField = TitleTextFieldView(textFieldType: .userPw)
    private let comfirmPwTitleTextField = TitleTextFieldView(textFieldType: .confirmPw)
    private let nextButton = UIButton()
    
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
        
        print("Push SignUpViewController")
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("Pop SignUpViewController")
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
            .assign(to: \.isEnabled, on: nextButton)
            .store(in: &cancellables)
        
        /// 비밀번호가 일치한지
        output.isPasswordMatching
            .sink { [weak self] isMatching in
                print(isMatching ? "true" : "false")
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = StringLiterals.NavigationTitle.signUp
        self.navigationItem.largeTitleDisplayMode = .inline
    }
    
    func setupStyle() {
        titleLabel.do {
            $0.text = "회원 정보"
        }
        
        duplicateIdButton.do {
            $0.setTitle("중복확인", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.isEnabled = false
            $0.setTitleColor(.black, for: .normal)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(titleLabel, userIdTitleTextField, duplicateIdButton, userPwTextField, comfirmPwTitleTextField, nextButton)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(34))
            $0.leading.equalToSuperview().offset(19)
        }
        
        userIdTitleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(view.convertByHeightRatio(24))
            $0.leading.equalToSuperview().offset(19)
        }
        
        duplicateIdButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(view.convertByHeightRatio(24))
            $0.leading.equalTo(userIdTitleTextField.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        userPwTextField.snp.makeConstraints {
            $0.top.equalTo(userIdTitleTextField.snp.bottom).offset(view.convertByHeightRatio(32))
            $0.horizontalEdges.equalToSuperview().inset(19)
        }
        
        comfirmPwTitleTextField.snp.makeConstraints {
            $0.top.equalTo(userPwTextField.snp.bottom).offset(view.convertByHeightRatio(28))
            $0.horizontalEdges.equalToSuperview().inset(19)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(19)
            $0.bottom.equalToSuperview().inset(31)
        }
    }
    
    func setupDelegate() {
        
    }
}
