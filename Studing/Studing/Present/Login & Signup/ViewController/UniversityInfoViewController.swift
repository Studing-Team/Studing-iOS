//
//  UniversityInfoViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import UIKit

import SnapKit
import Then

final class UniversityInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: UniversityInfoViewModel
    weak var coordinator: SignUpCoordinator?
    
    // MARK: - UI Properties
    
    private let universityTitleLabel = UILabel()
    private let universityTitleTextField = TitleTextFieldView(textFieldType: .university)
    private let nextButton = UIButton()
    
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
        view.backgroundColor = .white
        
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

        print("Pop UniversityInfoViewController")
    }
}

// MARK: - Private Bind Extensions

private extension UniversityInfoViewController {
    func bindViewModel() {
        
    }
}

// MARK: - Private Extensions

private extension UniversityInfoViewController {
    func setNavigationBar() {
        self.navigationItem.title = StringLiterals.NavigationTitle.signUp
        self.navigationItem.largeTitleDisplayMode = .inline
    }
    
    func setupStyle() {
        universityTitleLabel.do {
            $0.text = StringLiterals.Title.authUniversity
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(universityTitleLabel, universityTitleTextField, nextButton)
    }
    
    func setupLayout() {
        universityTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(34))
            $0.leading.equalToSuperview().offset(19)
        }
        
        universityTitleTextField.snp.makeConstraints {
            $0.top.equalTo(universityTitleLabel.snp.bottom).offset(view.convertByHeightRatio(18))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(19)
            $0.bottom.equalToSuperview().inset(31)
        }
    }
    
    func setupDelegate() {
        
    }
}
