//
//  MajorInfoViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import UIKit
import Combine

import SnapKit
import Then

final class MajorInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: MajorInfoViewModel
    weak var coordinator: SignUpCoordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let stepCountView = StepCountView(count: 3)
    private let majorTitleLabel = UILabel()
    private let majorTitleTextField = TitleTextFieldView(textFieldType: .major)
    private let nextButton = CustomButton(buttonStyle: .next)
    
    // MARK: - init
    
    init(viewModel: MajorInfoViewModel,
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
        
        print("Push MajorInfoViewController")
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
        
        print("Pop MajorInfoViewController")
    }
}

// MARK: - Private Bind Extensions

private extension MajorInfoViewController {
    func bindViewModel() {
        let input = MajorInfoViewModel.Input(nextTap: nextButton.tapPublisher)
        
        let output = viewModel.transform(input: input)
        
        output.TermsOfServiceViewAction
            .sink { [weak self] _ in
                self?.coordinator?.pushTermsOfServiceView()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension MajorInfoViewController {
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupStyle() {
        majorTitleLabel.do {
            $0.text = StringLiterals.Title.authMajor
            $0.font = .interHeadline2()
            $0.textColor = .black50
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(stepCountView, majorTitleLabel, majorTitleTextField, nextButton)
    }
    
    func setupLayout() {
        stepCountView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(20))
            $0.leading.equalToSuperview().offset(19)
        }
        
        majorTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stepCountView.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.leading.equalToSuperview().offset(19)
        }
        
        majorTitleTextField.snp.makeConstraints {
            $0.top.equalTo(majorTitleLabel.snp.bottom).offset(view.convertByHeightRatio(18))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
            $0.height.equalTo(50)
        }
    }
    
    func setupDelegate() {
        
    }
}
