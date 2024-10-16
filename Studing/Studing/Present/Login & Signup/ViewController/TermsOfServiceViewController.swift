//
//  TermsOfServiceViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class TermsOfServiceViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: TermsOfServiceViewModel
    weak var coordinator: SignUpCoordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let stepCountView = StepCountView(count: 5)
    private let serviceTitleLabel = UILabel()
    
    private let allAgreeView = UIView()
    private let allAgreeTitleLabel = UILabel()
    private let allCheckBoxButton = CheckBoxButton()
    

    private let serviceAgreeContainerView = UIView()
    
    private let mainStackView = UIStackView()
    
    private let serviceContainerView = UIView()
    private let essentialServiceAgreeTypeView = ArgreeTypeView(type: .essential)
    private let serviceBoxTitleLabel = UILabel()
    private let serviceBoxButton = CheckBoxButton()
    
    private let userInfoContainerView = UIView()
    private let essentialUserInfoAgreeTypeView = ArgreeTypeView(type: .essential)
    private let userInfoTitleLabel = UILabel()
    private let userInfoBoxButton = CheckBoxButton()
    
    private let marketingContainerView = UIView()
    private let selectMarketingAgreeTypeView = ArgreeTypeView(type: .select)
    private let marketingTitleLabel = UILabel()
    private let marketingBoxButton = CheckBoxButton()
    
    private let nextButton = CustomButton(buttonStyle: .next)
    
    // MARK: - init
    
    init(viewModel: TermsOfServiceViewModel,
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
        
        print("Push TermsOfServiceViewController")
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
        super.viewDidDisappear(animated)
        
        print("Pop TermsOfServiceViewController")
    }
}

// MARK: - Private Bind Extensions

private extension TermsOfServiceViewController {
    func bindViewModel() {
        
        let input = TermsOfServiceViewModel.Input(
            allCheckBoxTap: allCheckBoxButton.tapPublisher,
            serviceBoxTap: serviceBoxButton.tapPublisher,
            userInfoBoxTap: userInfoBoxButton.tapPublisher,
            marketingBoxTap: marketingBoxButton.tapPublisher,
            nextTap: nextButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.allCheckBoxTap
            .sink { [weak self] isSelected in
                self?.allCheckBoxButton.updateButtonState(isSelected)
            }
            .store(in: &cancellables)
        
        output.serviceBoxTap
            .sink { [weak self] isSelected in
                self?.serviceBoxButton.updateButtonState(isSelected)
            }
            .store(in: &cancellables)
        
        output.userInfoBoxTap
            .sink { [weak self] isSelected in
                self?.userInfoBoxButton.updateButtonState(isSelected)
            }
            .store(in: &cancellables)
        
        output.marketingBoxTap
            .sink { [weak self] isSelected in
                self?.marketingBoxButton.updateButtonState(isSelected)
            }
            .store(in: &cancellables)
        
        output.authUniversityViewAction
            .sink { [weak self] _ in
                self?.coordinator?.pushAuthUniversityView()
            }
            .store(in: &cancellables)
        
        output.isNextButtonEnabled
            .map { $0 ? ButtonState.activate : ButtonState.deactivate }
            .assign(to: \.buttonState, on: nextButton)
            .store(in: &cancellables)
        
    }
}

// MARK: - Private Extensions

private extension TermsOfServiceViewController {
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupStyle() {
        serviceTitleLabel.do {
            $0.text = StringLiterals.Title.authTermsofService
            $0.font = .interHeadline2()
            $0.textColor = .black50
            $0.numberOfLines = 2
        }
        
        allAgreeView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.primary50.cgColor
            $0.layer.borderWidth = 1
        }
        
        allAgreeTitleLabel.do {
            $0.text = "전체동의"
            $0.font = .interSubtitle2()
            $0.textColor = .primary50
        }
        
        mainStackView.do {
            $0.axis = .vertical
            $0.spacing = 19
            $0.distribution = .fillEqually
            $0.addArrangedSubviews(serviceContainerView, userInfoContainerView, marketingContainerView)
            $0.isUserInteractionEnabled = true
        }
        
        serviceAgreeContainerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.black10.cgColor
            $0.layer.borderWidth = 1
        }
        
        serviceBoxTitleLabel.do {
            $0.text = "서비스 이용약관"
            $0.font = .interBody2()
            $0.addBottomBorderWithAttributedString(underlineColor: .black50, textColor: .black50)
        }
        
        userInfoTitleLabel.do {
            $0.text = "개인정보 수집 및 이용동의"
            $0.font = .interBody2()
            $0.addBottomBorderWithAttributedString(underlineColor: .black50, textColor: .black50)
        }
        
        marketingTitleLabel.do {
            $0.text = "마케팅 정보 수신 동의"
            $0.font = .interBody2()
            $0.addBottomBorderWithAttributedString(underlineColor: .black50, textColor: .black50)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(stepCountView, serviceTitleLabel, allAgreeView, serviceAgreeContainerView, nextButton)
        
        allAgreeView.addSubviews(allAgreeTitleLabel, allCheckBoxButton)
        
        serviceContainerView.addSubviews(essentialServiceAgreeTypeView, serviceBoxTitleLabel, serviceBoxButton)
        userInfoContainerView.addSubviews(essentialUserInfoAgreeTypeView, userInfoTitleLabel ,userInfoBoxButton)
        marketingContainerView.addSubviews(selectMarketingAgreeTypeView, marketingTitleLabel, marketingBoxButton)
        
        serviceAgreeContainerView.addSubview(mainStackView)
    }
    
    func setupLayout() {
        stepCountView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(20))
            $0.leading.equalToSuperview().offset(19)
        }
        
        serviceTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stepCountView.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.horizontalEdges.equalToSuperview().inset(19)
        }
        
        allAgreeView.snp.makeConstraints {
            $0.top.equalTo(serviceTitleLabel.snp.bottom).offset(view.convertByHeightRatio(30))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        
        allAgreeTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
        }
        
        allCheckBoxButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(allAgreeTitleLabel.snp.trailing).offset(view.convertByHeightRatio(227))
            $0.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(20)
            $0.width.equalTo(20)
        }
        
        serviceAgreeContainerView.snp.makeConstraints {
            $0.top.equalTo(allAgreeView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().inset(20)
        }

        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        // 서비스 이용약관 뷰 레이아웃 설정
        setupCommonLayout(container: serviceContainerView,
                          agreeTypeView: essentialServiceAgreeTypeView,
                          titleLabel: serviceBoxTitleLabel,
                          boxButton: serviceBoxButton)

        // 개인정보 수집 컨테이너 뷰 레이아웃 설정
        setupCommonLayout(container: userInfoContainerView,
                          agreeTypeView: essentialUserInfoAgreeTypeView,
                          titleLabel: userInfoTitleLabel,
                          boxButton: userInfoBoxButton)

        // 마케팅 컨테이너 뷰 레이아웃 설정
        setupCommonLayout(container: marketingContainerView,
                          agreeTypeView: selectMarketingAgreeTypeView,
                          titleLabel: marketingTitleLabel,
                          boxButton: marketingBoxButton)
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(serviceAgreeContainerView.snp.bottom).offset(view.convertByHeightRatio(278))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(48)
        }
    }
    
    func setupCommonLayout(container: UIView, agreeTypeView: UIView, titleLabel: UILabel, boxButton: UIButton) {
        container.addSubviews(agreeTypeView, titleLabel, boxButton)
        
        agreeTypeView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(agreeTypeView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        boxButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
            $0.width.equalTo(20)
        }
    }
    
    func setupDelegate() {
        
    }
}
