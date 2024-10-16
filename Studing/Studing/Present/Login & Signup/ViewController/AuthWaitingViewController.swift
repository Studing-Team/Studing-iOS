//
//  AuthWaitingViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/15/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class AuthWaitingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: AuthWaitingViewModel
    weak var coordinator: SignUpCoordinator?
    
    // MARK: - Combine Publishers Properties

    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let authWaitingTitleLabel = UILabel()
    private let authWaitingSubTitleLabel = UILabel()
    private let authBackgroundView = DashedLineBorderView()
    private let authWaitCheckView = AuthWaitCheckView()
    
    private let authWaitingSubTitleLabel2 = UILabel()
    private let authWaitingSubTitleLabel3 = UILabel()
    
    private let notificationButton = CustomButton(buttonStyle: .notification)
    private let showStudingButton = CustomButton(buttonStyle: .showStuding)
    
    // MARK: - init
    
    init(viewModel: AuthWaitingViewModel,
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
        
        print("Push AuthWaitingViewController")
        view.backgroundColor = .signupBackground
        
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
        print("Pop AuthWaitingViewController")
    }
}

// MARK: - Private Bind Extensions

private extension AuthWaitingViewController {
    func bindViewModel() {
        
        let input = AuthWaitingViewModel.Input(
            showStudingTap: showStudingButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)

        output.showStudingViewAction
            .sink { [weak self] _ in
                self?.coordinator?.pushSuccessSignUpView()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension AuthWaitingViewController {
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupStyle() {
        authWaitingTitleLabel.do {
            $0.text = StringLiterals.Title.authenticatingTitle
            $0.font = .interHeadline2()
            $0.textColor = .black50
            $0.numberOfLines = 2
        }
        
        authWaitingSubTitleLabel.do {
            $0.text = StringLiterals.Authentication.AuthenticatingSubTitle2
            $0.font = .interBody3()
            $0.textColor = .black40
            $0.numberOfLines = 2
        }
        
        authBackgroundView.do {
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .white
            $0.clipsToBounds = true
        }
        
        authWaitingSubTitleLabel2.do {
            $0.text = StringLiterals.Authentication.AuthenticatingTitle2
            $0.font = .interSubtitle1()
            $0.textColor = .black50
            $0.numberOfLines = 2
        }
        
        authWaitingSubTitleLabel3.do {
            $0.text = StringLiterals.Authentication.AuthenticatingSubTitle3
            $0.font = .interBody3()
            $0.textColor = .black40
        }
        
        showStudingButton.do {
            $0.layer.borderColor = UIColor.black10.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 25.0
            $0.clipsToBounds = true
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(authWaitingTitleLabel, authWaitingSubTitleLabel, authBackgroundView, authWaitingSubTitleLabel2, authWaitingSubTitleLabel3, notificationButton, showStudingButton)
        
        authBackgroundView.addSubviews(authWaitCheckView)
    }
    
    func setupLayout() {
        authWaitingTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(59))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        authWaitingSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(authWaitingTitleLabel.snp.bottom).offset(view.convertByHeightRatio(10))
            $0.leading.equalToSuperview().offset(22.5)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        authBackgroundView.snp.makeConstraints {
            $0.top.equalTo(authWaitingSubTitleLabel.snp.bottom).offset(view.convertByHeightRatio(25))
            $0.horizontalEdges.equalToSuperview().inset(21)
        }
        
        authWaitCheckView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.convertByHeightRatio(104))
            $0.horizontalEdges.equalToSuperview().inset(21)
            $0.bottom.equalToSuperview().inset(view.convertByHeightRatio(100))
        }
        
        authWaitingSubTitleLabel2.snp.makeConstraints {
            $0.top.equalTo(authBackgroundView.snp.bottom).offset(view.convertByHeightRatio(25))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        authWaitingSubTitleLabel3.snp.makeConstraints {
            $0.top.equalTo(authWaitingSubTitleLabel2.snp.bottom).offset(view.convertByHeightRatio(10))
            $0.horizontalEdges.equalToSuperview().inset(21)
        }
        
        notificationButton.snp.makeConstraints {
            $0.top.equalTo(authWaitingSubTitleLabel3.snp.bottom).offset(view.convertByHeightRatio(51))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
        
        showStudingButton.snp.makeConstraints {
            $0.top.equalTo(notificationButton.snp.bottom).offset(view.convertByHeightRatio(8))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(48)
        }
    }
    
    func setupDelegate() {
        
    }
}
