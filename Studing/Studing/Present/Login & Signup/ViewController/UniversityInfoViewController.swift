//
//  UniversityInfoViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import UIKit
import Combine

import SnapKit
import Then

final class UniversityInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: UniversityInfoViewModel
    weak var coordinator: SignUpCoordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let stepCountView = StepCountView(count: 2)
    private let universityTitleLabel = UILabel()
    private let universityTitleTextField = TitleTextFieldView(textFieldType: .university)
    private let nextButton = CustomButton(buttonStyle: .next)
    
    // MARK: - init
    
    init(viewModel: UniversityInfoViewModel,
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
        
        print("Push UniversityInfoViewController")
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
        print("wiewWill UniversityInfoViewController")
        setNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        print("Pop UniversityInfoViewController")
    }
}

// MARK: - Private Bind Extensions

private extension UniversityInfoViewController {
    func bindViewModel() {
        let input = UniversityInfoViewModel.Input(nextTap: nextButton.tapPublisher)
        
        let output = viewModel.transform(input: input)
        
        output.majorInfoViewAction
            .sink { [weak self] _ in
                self?.coordinator?.pushMajorInfoView()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension UniversityInfoViewController {
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupStyle() {
        universityTitleLabel.do {
            $0.text = StringLiterals.Title.authUniversity
            $0.font = .interHeadline2()
            $0.textColor = .black50
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(stepCountView, universityTitleLabel, universityTitleTextField, nextButton)
    }
    
    func setupLayout() {
        stepCountView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(20))
            $0.leading.equalToSuperview().offset(19)
        }
        
        universityTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stepCountView.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.leading.equalToSuperview().offset(19)
        }
        
        universityTitleTextField.snp.makeConstraints {
            $0.top.equalTo(universityTitleLabel.snp.bottom).offset(view.convertByHeightRatio(18))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().inset(20)
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
