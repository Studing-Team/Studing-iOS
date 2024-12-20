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

enum SearchResultState {
    case noExistsResult
    case existsResult
    case noInput
}

final class UniversityInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: UniversityInfoViewModel
    weak var coordinator: SignUpCoordinator?
    
    private var selectedSearchResultSubject = PassthroughSubject<String, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let stepCountView = StepCountView(count: 2)
    private let universityTitleLabel = UILabel()
    private let universityTitleTextField = TitleTextFieldView(textFieldType: .university)
    private let searchResultCollectionView = SearchResultCollectionView<UniversityInfoEntity>(searchType: .university)
    private let noExistsSearchResultView = NoExistsSearchResultView(serachResultType: .university)
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
        let input = UniversityInfoViewModel.Input(
            universityName: universityTitleTextField.textPublisher.eraseToAnyPublisher(),
            selectUniversityName: selectedSearchResultSubject.eraseToAnyPublisher(),
            nextTap: nextButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.searchUnivsersityResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results, searchName in
                if results.isEmpty && !searchName.isEmpty { // 입력 값 O, 검색 결과 X
                    self?.updateLayout(state: .noExistsResult)
                    self?.universityTitleTextField.statePublisher.send(.select(type: .university))
                } else if !results.isEmpty && !searchName.isEmpty { // 입력 값 O, 검색 결과 O
                    self?.searchResultCollectionView.updateData(with: results, serachName: searchName)
                    self?.updateLayout(state: .existsResult)
                    self?.universityTitleTextField.statePublisher.send(.select(type: .university))
                } else { // 입력 값 X
                    self?.updateLayout(state: .noInput)
                    self?.universityTitleTextField.statePublisher.send(.normal(type: .university))
                }
            }
            .store(in: &cancellables)
        
        output.selectUniversity
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectName in
//                self?.view.endEditing(true)
                print("눌림:", selectName)
                self?.searchResultCollectionView.isHidden = true
                self?.universityTitleTextField.textField.text = selectName
                self?.universityTitleTextField.setState(.success(type: .university))
                self?.universityTitleTextField.updateRightButtonColor(.success(type: .university))
                self?.updateLayout(state: .noInput)
                
//                DispatchQueue.main.async { [weak self] in
//                    self?.searchResultCollectionView.isHidden = true
//                    self?.view.layoutIfNeeded() // 레이아웃 강제 반영
//                }
                // isHidden 변경
//                self?.view.endEditing(true)
//                self?.searchResultCollectionView.isHidden = true
//                print("isHidden 상태:", self?.searchResultCollectionView.isHidden ?? false)
//                // 레이아웃 강제 업데이트
//                self?.view.layoutIfNeeded()
            }
            .store(in: &cancellables)
        
        output.isEnableButton
            .map { $0 ? ButtonState.activate : ButtonState.deactivate }
            .assign(to: \.buttonState, on: nextButton)
            .store(in: &cancellables)
        
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
        view.addSubviews(stepCountView, universityTitleLabel, universityTitleTextField, searchResultCollectionView, nextButton)
    }
    
    func setupLayout() {
        stepCountView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(20))
            $0.leading.equalToSuperview().offset(19)
        }
        
        universityTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stepCountView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(19)
        }
        
        universityTitleTextField.snp.makeConstraints {
            $0.top.equalTo(universityTitleLabel.snp.bottom).offset(view.convertByHeightRatio(30))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        searchResultCollectionView.snp.makeConstraints {
            $0.top.equalTo(universityTitleTextField.snp.bottom).offset(view.convertByHeightRatio(30))
            $0.horizontalEdges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(searchResultCollectionView.snp.bottom).offset(view.convertByHeightRatio(8))
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
            $0.top.equalTo(universityTitleTextField.snp.bottom).offset(view.convertByHeightRatio(30))
            $0.horizontalEdges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(searchResultCollectionView.snp.bottom).offset(view.convertByHeightRatio(8))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(48)
        }
    }
    
    func noExistsResultUpdateLayout() {
        searchResultCollectionView.isHidden = true
        noExistsSearchResultView.isHidden = false
        
        if !view.subviews.contains(noExistsSearchResultView) {
            view.addSubview(noExistsSearchResultView)
        }
        
        noExistsSearchResultView.snp.remakeConstraints {
            $0.top.equalTo(universityTitleTextField.snp.bottom).offset(view.convertByHeightRatio(98))
            $0.horizontalEdges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(noExistsSearchResultView.snp.bottom).offset(view.convertByHeightRatio(8))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(48)
        }
    }
    
    func noInputUpdateLayout() {
        DispatchQueue.main.async { [weak self] in
            self?.searchResultCollectionView.isHidden = true
            self?.noExistsSearchResultView.isHidden = true
            
            self?.view.layoutIfNeeded() // 레이아웃 강제 반영
        }
    }
    
    func setupDelegate() {
        self.searchResultCollectionView.searchResultDelegate = self
    }
}

// MARK: - SearchResultCellDelegate

extension UniversityInfoViewController: SearchResultCellDelegate {
    func didSelectSearchResult(_ result: any SearchResultModel) {
        if let universityResult = result as? UniversityInfoEntity {
            universityTitleTextField.textPublisher.send(universityResult.resultData)
            selectedSearchResultSubject.send(universityResult.resultData)
        }
    }
}
