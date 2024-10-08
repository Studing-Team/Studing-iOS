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
    
    // MARK: - Combine Publishers Properties
    
    private let didSelectItemSubject = PassthroughSubject<IndexPath, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let stepCountView = StepCountView(count: 4)
    private let studentIdTitleLabel = UILabel()
    private lazy var studentIdTitleTextField = TitleTextFieldView(textFieldType: .studentId)
    private let studentIdInputCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
            nextTap: nextButton.tapPublisher,
            selectedIndexPath: didSelectItemSubject.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.selectedStudentId
            .assign(to: \.text, on: studentIdTitleTextField.textField)
            .store(in: &cancellables)
        
        output.shouldHideCollectionView
            .assign(to: \.isHidden, on : studentIdInputCollectionView)
            .store(in: &cancellables)
        
        output.isNextButtonEnabled
            .map { $0 ? ButtonState.activate : ButtonState.deactivate }
            .assign(to: \.buttonState, on: nextButton)
            .store(in: &cancellables)
        
        output.TermsOfServiceViewAction
            .sink { [weak self] _ in
                self?.coordinator?.pushTermsOfServiceView()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension StudentIdViewController {
    
    @objc private func textFieldTapped() {
        studentIdInputCollectionView.isHidden.toggle()
        let hidden = studentIdInputCollectionView.isHidden
        
        studentIdTitleTextField.setState(hidden == false ? .select(type: .studentId) : .normal(type: .studentId))
    }
    
    func setupStyle() {
        studentIdTitleLabel.do {
            $0.text = StringLiterals.Title.authStudentID
            $0.font = .interHeadline2()
            $0.textColor = .black50
        }
        
        studentIdTitleTextField.do {
            $0.textField.inputView = UIView()
            $0.textField.tintColor = .clear
            $0.textField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(textFieldTapped)))
        }
        
        studentIdInputCollectionView.do {
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.isHidden = true
            $0.allowsMultipleSelection = false
            $0.register(StudentIdInputCollectionCell.self, forCellWithReuseIdentifier: StudentIdInputCollectionCell.className)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black10.cgColor
            $0.layer.cornerRadius = 10
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(stepCountView, studentIdTitleLabel, studentIdTitleTextField, studentIdInputCollectionView, nextButton)
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
        
        studentIdTitleTextField.snp.makeConstraints {
            $0.top.equalTo(studentIdTitleLabel.snp.bottom).offset(view.convertByHeightRatio(30))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        studentIdInputCollectionView.snp.makeConstraints {
            $0.top.equalTo(studentIdTitleTextField.snp.bottom).offset(10)
            $0.left.right.equalTo(studentIdTitleTextField)
            $0.height.equalTo(view.convertByHeightRatio(384))  // 원하는 높이로 조정
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
            $0.height.equalTo(50)
        }
    }
    
    func setupDelegate() {
        self.studentIdInputCollectionView.delegate = self
        self.studentIdInputCollectionView.dataSource = self
    }
}

extension StudentIdViewController: UICollectionViewDelegateFlowLayout {
    // sizeForItemAt: 각 Cell의 크기를 CGSize 형태로 return
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.convertByWidthRatio(335), height: 32)
    }
    
    // ContentInset: Cell에서 Content 외부에 존재하는 Inset의 크기를 결정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    // minimumLineSpacing: Cell 들의 위, 아래 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension StudentIdViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.studentIdData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudentIdInputCollectionCell.className, for: indexPath) as? StudentIdInputCollectionCell else { return UICollectionViewCell() }
        
        let data = viewModel.studentIdData[indexPath.row]
        cell.configureCell(studentId: data.studentId)
        
        return cell
    }
}

extension StudentIdViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // 현재 선택된 셀의 indexPath
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
            
            // 이미 선택된 셀이 있다면 선택을 해제
            collectionView.deselectItem(at: selectedIndexPath, animated: true)
            if let cell = collectionView.cellForItem(at: selectedIndexPath) as? StudentIdInputCollectionCell {
                cell.notSelectedCell()
            }
        }
        
        // 새로운 선택을 허용
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? StudentIdInputCollectionCell {
            cell.selectedCell()
        }
        
        didSelectItemSubject.send(indexPath)
    }
}
