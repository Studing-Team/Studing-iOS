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
    
    private var selectedSearchResultSubject = PassthroughSubject<String, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let stepCountView = StepCountView(count: 3)
    private let majorTitleLabel = UILabel()
    private let majorTitleTextField = TitleTextFieldView(textFieldType: .major)
    private var searchResultCollectionView = SearchResultCollectionView<MajorInfoModel>(searchType: .major)
    private let noExistsSearchResultView = NoExistsSearchResultView(serachResultType: .major)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("Pop MajorInfoViewController")
    }
}

// MARK: - Private Bind Extensions

private extension MajorInfoViewController {
    func bindViewModel() {
        let input = MajorInfoViewModel.Input(
            majorName: majorTitleTextField.textPublisher.eraseToAnyPublisher(),
            selectMajorName: selectedSearchResultSubject.eraseToAnyPublisher(),
            nextTap: nextButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.searchMajorResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results, searchName in
                if results.isEmpty && !searchName.isEmpty { // 입력 값 O, 검색 결과 X
                    self?.updateLayout(state: .noExistsResult)
                } else if !results.isEmpty && !searchName.isEmpty { // 입력 값 O, 검색 결과 O
                    self?.searchResultCollectionView.updateData(with: results, serachName: searchName)
                    self?.updateLayout(state: .existsResult)
                } else { // 입력 값 X
                    self?.updateLayout(state: .noInput)
                }
            }
            .store(in: &cancellables)
        
        output.selectUniversity
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectName in
                self?.majorTitleTextField.textField.text = selectName
                self?.majorTitleTextField.setState(.success(type: .major))
                self?.majorTitleTextField.updateRightButtonColor(.success(type: .major))
                self?.updateLayout(state: .noInput)
            }
            .store(in: &cancellables)
        
        output.isEnableButton
            .map { $0 ? ButtonState.activate : ButtonState.deactivate }
            .assign(to: \.buttonState, on: nextButton)
            .store(in: &cancellables)
        
        output.TermsOfServiceViewAction
            .sink { [weak self] _ in
                self?.coordinator?.pushStudentIdView()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension MajorInfoViewController {
    func setupStyle() {
        majorTitleLabel.do {
            $0.text = StringLiterals.Title.authMajor
            $0.font = .interHeadline2()
            $0.textColor = .black50
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(stepCountView, majorTitleLabel, majorTitleTextField, searchResultCollectionView, nextButton)
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
        
        searchResultCollectionView.snp.makeConstraints {
            $0.top.equalTo(majorTitleTextField.snp.bottom).offset(view.convertByHeightRatio(30))
            $0.horizontalEdges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(searchResultCollectionView.snp.bottom).offset(view.convertByHeightRatio(30))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(48)
        }
    }
    
    func updateLayout(state: SearchResultState) {
        switch state {
        case .existsResult:
            existsResultUpdateLayout()
        case .noExistsResult:
            noExistsResultUpdateLayout()
        case .noInput:
            noInputUpdateLayout()
        }
        
        view.layoutIfNeeded()
    }
    
    func existsResultUpdateLayout() {
        searchResultCollectionView.isHidden = false
        noExistsSearchResultView.isHidden = true
        
        searchResultCollectionView.snp.remakeConstraints {
            $0.top.equalTo(majorTitleTextField.snp.bottom).offset(view.convertByHeightRatio(30))
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-view.convertByHeightRatio(30))
        }
    }
    
    func noExistsResultUpdateLayout() {
        searchResultCollectionView.isHidden = true
        noExistsSearchResultView.isHidden = false
        
        if !view.subviews.contains(noExistsSearchResultView) {
            view.addSubview(noExistsSearchResultView)
        }
        
        noExistsSearchResultView.snp.remakeConstraints {
            $0.top.equalTo(majorTitleTextField.snp.bottom).offset(view.convertByHeightRatio(134))
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-view.convertByHeightRatio(8))
        }
    }
    
    func noInputUpdateLayout() {
        searchResultCollectionView.isHidden = true
        noExistsSearchResultView.isHidden = true
    }
    
    func setupDelegate() {
        self.searchResultCollectionView.searchResultDelegate = self
    }
}

// MARK: - SearchResultCellDelegate

extension MajorInfoViewController: SearchResultCellDelegate {
    func didSelectSearchResult(_ result: any SearchResultModel) {
        if let majorInfoModel = result as? MajorInfoModel {
            majorTitleTextField.textPublisher.send(majorInfoModel.resultData)
            selectedSearchResultSubject.send(majorInfoModel.resultData)
        }
    }
}
