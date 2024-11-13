//
//  AuthUniversityViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/16/24.
//

import Combine
import UIKit

import SnapKit
import Then
import PhotosUI

final class AuthUniversityViewController: UIViewController {

    // MARK: - Properties
    
    private var viewModel: AuthUniversityViewModel
    weak var coordinator: SignUpCoordinator?
    
    // MARK: - Combine Publishers Properties

    private let selectedImageDataSubject = CurrentValueSubject<Data?, Never>(nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let stepCountView = StepCountView(count: 6)
    private let authTitleLabel = UILabel()
    private let authSubTitleLabel = UILabel()
    
    private let uploadBackgroundView = DashedLineBorderView()
    private let uploadImageView = UIImageView()
    private lazy var seletedImageView = UIImageView()
    
    private let uploadStudentCardTitle = UILabel()
    private let studentCardButton = CustomButton(buttonStyle: .studentCard)
    private let userNameTitleTextField = TitleTextFieldView(textFieldType: .userName)
    private let studentIdTitleTextField = TitleTextFieldView(textFieldType: .allStudentId)
    private let authenticationButton = CustomButton(buttonStyle: .authentication)
    
    private lazy var imagePicker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        return picker
    }()
    
    // MARK: - init
    
    init(viewModel: AuthUniversityViewModel,
         coordinator: SignUpCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Push AuthUniversityViewController")
        view.backgroundColor = .signupBackground
        
//        hideKeyboard()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
        
        setupKeyboardHandling()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Pop AuthUniversityViewController")
    }
}

// MARK: - Private Bind Extensions

private extension AuthUniversityViewController {
    func bindViewModel() {
        
        let input = AuthUniversityViewModel.Input(
            studentCardTap: studentCardButton.tapPublisher, 
            selectedImageData: selectedImageDataSubject,
            userName: userNameTitleTextField.textPublisher,
            allStudentId: studentIdTitleTextField.textPublisher,
            nextTap: authenticationButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)

        output.openImagePicker
            .sink { [weak self] _ in
                self?.presentPHPicker()
            }
            .store(in: &cancellables)
        
        output.isSelectedImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSelected in
                self?.updateViewState(isImageSelected: isSelected)
            }
            .store(in: &cancellables)
        
        output.isNextButtonEnabled
            .map { $0 ? ButtonState.activate : ButtonState.deactivate }
            .assign(to: \.buttonState, on: authenticationButton)
            .store(in: &cancellables)
        
        output.authUniversityViewAction
            .sink { [weak self] _ in
                self?.coordinator?.pushAuthWaitingView()
            }
            .store(in: &cancellables)
    }
}
// MARK: - Private Extensions

private extension AuthUniversityViewController {
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupStyle() {
        authTitleLabel.do {
            $0.text = StringLiterals.Title.authUniversityStudent
            $0.font = .interHeadline3()
            $0.textColor = .black50
            $0.numberOfLines = 2
        }
        
        authSubTitleLabel.do {
            $0.text = StringLiterals.Authentication.universitySubTitle
            $0.font = .interBody3()
            $0.textColor = .black40
            $0.numberOfLines = 2
        }
        
        seletedImageView.do {
            $0.isHidden = true
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }
        
        uploadBackgroundView.do {
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .white
            $0.clipsToBounds = true
        }
        
        uploadImageView.do {
            $0.image = UIImage(named: "uploadImage")
        }
        
        uploadStudentCardTitle.do {
            $0.text = StringLiterals.Authentication.studentCardTitle
            $0.font = .interCaption12()
            $0.textColor = .black40
        }
        
        authenticationButton.do {
            $0.setTitle(StringLiterals.Button.authTitle, for: .normal)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(stepCountView, authTitleLabel, authSubTitleLabel, uploadBackgroundView, seletedImageView, userNameTitleTextField, studentIdTitleTextField, authenticationButton)
        
        uploadBackgroundView.addSubviews(uploadImageView, uploadStudentCardTitle, studentCardButton)
    }
    
    func setupLayout() {
        stepCountView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(20))
            $0.leading.equalToSuperview().offset(19)
        }
        
        authTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stepCountView.snp.bottom).offset(view.convertByHeightRatio(15))
            $0.leading.equalToSuperview().offset(23)
            $0.trailing.equalToSuperview().inset(132)
        }
        
        authSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(authTitleLabel.snp.bottom).offset(view.convertByHeightRatio(10))
            $0.leading.equalToSuperview().offset(23)
        }
        
        uploadBackgroundView.snp.makeConstraints {
            $0.top.equalTo(authSubTitleLabel.snp.bottom).offset(view.convertByHeightRatio(36))
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        seletedImageView.snp.makeConstraints {
            $0.top.equalTo(authSubTitleLabel.snp.bottom).offset(view.convertByHeightRatio(36))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(view.convertByHeightRatio(186))
        }
        
        userNameTitleTextField.snp.makeConstraints {
            $0.top.equalTo(uploadBackgroundView.snp.bottom).offset(view.convertByHeightRatio(40))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        studentIdTitleTextField.snp.makeConstraints {
            $0.top.equalTo(userNameTitleTextField.snp.bottom).offset(view.convertByHeightRatio(20))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        authenticationButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(48)
        }
        
        uploadImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(view.convertByWidthRatio(60))
            $0.height.equalTo(view.convertByHeightRatio(60))
        }
        
        uploadStudentCardTitle.snp.makeConstraints {
            $0.top.equalTo(uploadImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        studentCardButton.snp.makeConstraints {
            $0.top.equalTo(uploadStudentCardTitle.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(29)
            $0.width.equalTo(212)
            $0.height.equalTo(24)
        }
    }
    
    func updateViewState(isImageSelected: Bool) {
        uploadBackgroundView.isHidden = isImageSelected
        seletedImageView.isHidden = !isImageSelected

        if isImageSelected {
            userNameTitleTextField.snp.remakeConstraints {
                $0.top.equalTo(seletedImageView.snp.bottom).offset(view.convertByHeightRatio(40))
                $0.leading.equalToSuperview().offset(19)
                $0.trailing.equalToSuperview().offset(-20)
            }
        } else {
            userNameTitleTextField.snp.remakeConstraints {
                $0.top.equalTo(uploadBackgroundView.snp.bottom).offset(view.convertByHeightRatio(40))
                $0.leading.equalToSuperview().offset(19)
                $0.trailing.equalToSuperview().offset(-20)
            }
        }

        view.layoutIfNeeded()
    }
    
    func setupDelegate() {
        imagePicker.delegate = self
    }
    
    private func presentPHPicker() {
        present(imagePicker, animated: true)
    }
}


extension AuthUniversityViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider else { return }

        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self, let image = image as? UIImage else { return }
                    
                    if let imageData = image.jpegData(compressionQuality: 0.1) {
                        
                        self.seletedImageView.image = UIImage(data: imageData)
                        
                        print("사진 용량", imageData.count)
                        self.selectedImageDataSubject.send(imageData)
                    }
                }
            }
        }
    }
}
