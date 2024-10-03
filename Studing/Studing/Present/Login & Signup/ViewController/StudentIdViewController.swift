//
//  StudentIdViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/3/24.
//

import UIKit
import Combine

import SnapKit
import Then

final class StudentIdViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: StudentIdViewModel
    weak var coordinator: SignUpCoordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let stepCountView = StepCountView(count: 4)
    private let studentIdTitleLabel = UILabel()
    private let studentIdTitleTextField = TitleTextFieldView(textFieldType: .studentId)
    private let nextButton = CustomButton(buttonStyle: .next)
    
    // MARK: - init
    
    init(viewModel: StudentIdViewModel,
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
        
        print("Push StudentIDViewController")
        view.backgroundColor = .signupBackground
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("Pop StudentIDViewController")
    }
}

// MARK: - Private Bind Extensions

private extension StudentIdViewController {
    func bindViewModel() {
        let input = StudentIdViewModel.Input(
            nextTap: nextButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
    
        output.TermsOfServiceViewAction
            .sink { [weak self] _ in
                self?.coordinator?.pushTermsOfServiceView()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension StudentIdViewController {
    func setupStyle() {
        studentIdTitleLabel.do {
            $0.text = StringLiterals.Title.authStudentID
            $0.font = .interHeadline2()
            $0.textColor = .black50
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(stepCountView, studentIdTitleLabel, nextButton)
    }
    
    func setupLayout() {
        stepCountView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(20))
            $0.leading.equalToSuperview().offset(19)
        }
        
        studentIdTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stepCountView.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.leading.equalToSuperview().offset(19)
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
