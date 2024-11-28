//
//  PostAnnounceViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/20/24.
//

import Combine
import UIKit
import PhotosUI

import SnapKit
import Then

final class PostAnnounceViewController: UIViewController {
    
    // MARK: - Properties
    
    // 선택된 이미지의 identifier를 저장할 배열 추가
    private var selectedAssetIdentifiers: [String] = []
    
    private var selectedImagesCount = 0
    private var postAnnounceViewModel: PostAnnounceViewModel
    weak var coordinator: HomeCoordinator?
    
    // 최소 높이 상수 추가
    private let minimumTextViewHeight: CGFloat = 150
    
    // 높이 제약조건을 저장할 프로퍼티
    private var textViewHeightConstraint: Constraint?

    // MARK: - UI Properties
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    
    private let imageScrollView = UIScrollView()
    private let imageStackView = UIStackView()
    
    private let titleSectionView = UIStackView()
    private let textFieldHeader = UILabel()
    private let titleTextField = UITextField()
    
    private let textSectionView = UIStackView()
    private let textViewHeader = UILabel()
    private let contentTextView = UITextView()
    private let placeholderLabel = UILabel()
    
    private let tagSectionView = UIStackView()
    private let tagViewHeader = UILabel()
    private let tagStackView = UIStackView()
    private let announceTagView = UIButton()
    private let eventTagView = UIButton()
    
    private let selectPhotoButton = UIButton()
    
    private let announceButton = AnnounceTagButton(buttonStyle: .announce)
    private let eventButton = AnnounceTagButton(buttonStyle: .event)
    
    private let postButton = CustomButton(buttonStyle: .postAnnounce)
    
    // MARK: - Combine Publishers Properties

    private let tagButtonSubject = PassthroughSubject<TagStyle, Never>()
    private let selectedImageDataSubject = CurrentValueSubject<[Data]?, Never>(nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - init
    
    init(postAnnounceViewModel: PostAnnounceViewModel,
         coordinator: HomeCoordinator) {
        self.postAnnounceViewModel = postAnnounceViewModel
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
        
        print("Push PostAnnounceViewController")
        self.view.backgroundColor = .black5
        
        hideKeyboard()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func tagButtonTapped(_ sender: AnnounceTagButton) {
       // 다른 버튼 선택 해제
        announceButton.buttonState = (sender == announceButton) ? .select : .notSelct
        eventButton.buttonState = (sender == eventButton) ? .select : .notSelct
        
        // 선택된 버튼의 스타일을 Subject로 전달
       tagButtonSubject.send(sender.buttonStyle)
    }
    
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        // ScrollView에 키보드 높이만큼 bottom inset 추가
        scrollView.contentInset.bottom = keyboardHeight + 30 // 여유 공간
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight + 30
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        // ScrollView의 contentInset 원복
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}

private extension PostAnnounceViewController {
    func bindViewModel() {
        let input = PostAnnounceViewModel.Input(
            selectImageButtonTap: selectPhotoButton.tapPublisher,
            createAnnounceButtonTap: postButton.tapPublisher, 
            titleText: titleTextField.textPublisher, 
            contentText: contentTextView.textPublisher, 
            tagButtonText: tagButtonSubject.eraseToAnyPublisher()
        )
        
        let output = postAnnounceViewModel.transform(input: input)
        
        output.isEnableCreateButton
            .map { $0 ? ButtonState.activate : ButtonState.deactivate }
            .assign(to: \.buttonState, on: postButton)
            .store(in: &cancellables)
        
        output.selectImageButtonTap
            .sink { [weak self] _ in
                self?.presentPHPicker()
            }
            .store(in: &cancellables)
        
        output.createAnnounceResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                if result {
                    if let customNavController = self?.navigationController as? CustomAnnouceNavigationController {
                        // CustomAnnouceNavigationController인 경우
                        customNavController.dismiss(animated: true)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension PostAnnounceViewController {
    func setupStyle() {
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0)
        }
        
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 20
        }
        
        imageScrollView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        
        imageStackView.do {
            $0.axis = .horizontal
            $0.alignment = .bottom
            $0.spacing = 8
        }
        
        titleTextField.do {
            $0.font = .interBody1()
            $0.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요", attributes: [.font: UIFont.interBody1(), .foregroundColor: UIColor.black30])
            $0.backgroundColor = .white
            $0.leftViewMode = .always
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.black10.cgColor
            $0.layer.borderWidth = 1
        }

        contentTextView.do {
            $0.font = .interBody1()
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.black10.cgColor
            $0.layer.borderWidth = 1
            $0.textContainerInset = UIEdgeInsets(top: 15, left: 13, bottom: 15, right: 13)
            $0.delegate = self
            $0.isScrollEnabled = false  // 스크롤 비활성화로 자동 크기 조절
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        textFieldHeader.do {
            $0.text = "제목"
        }
        
        textViewHeader.do {
            $0.text = "내용"
        }
        
        tagViewHeader.do {
            $0.text = "태그"
        }
        
        contentTextView.do {
            $0.isScrollEnabled = false
        }
        
        tagStackView.do {
            $0.axis = .horizontal
            $0.alignment = .leading
            $0.distribution = .fill
            $0.spacing = 8
        }
        
        [titleSectionView, textSectionView].forEach {
            $0.axis = .vertical
            $0.spacing = 10
        }
        
        tagSectionView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.alignment = .leading
        }
        
        [textFieldHeader, textViewHeader, tagViewHeader].forEach {
            $0.font = .interSubtitle2()
            $0.textColor = .black40
        }
        
        selectPhotoButton.do {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(resource: .photoCamera)
            config.imagePlacement = .top
            config.imagePadding = 4
            config.titleAlignment = .center
            var titleAttr = AttributedString("\(selectedImagesCount)/10")
            titleAttr.font = UIFont.interChips12()
            titleAttr.foregroundColor = .black30
            config.attributedTitle = titleAttr
            
            config.baseForegroundColor = .black30
            
            config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 10, trailing: 20)
            
            config.background.backgroundColor = .white
            config.background.cornerRadius = 8
            config.background.strokeWidth = 1
            config.background.strokeColor = .black10
            
            $0.configuration = config
        }
        
        placeholderLabel.do {
            $0.text = "공지사항 내용을 입력해주세요"
            $0.font = .interBody1()
            $0.textColor = .black30
        }
        
        announceButton.addTarget(self, action: #selector(tagButtonTapped(_:)), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(tagButtonTapped(_:)), for: .touchUpInside)
    }
    
    func setupHierarchy() {
        view.addSubviews(scrollView, postButton)
        scrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubviews(imageScrollView,
                                             titleSectionView,
                                             textSectionView,
                                             tagSectionView)
        
        imageScrollView.addSubview(imageStackView)
        
        imageStackView.addArrangedSubview(selectPhotoButton)
        
        titleSectionView.addArrangedSubviews(textFieldHeader, titleTextField)
        
        textSectionView.addArrangedSubviews(textViewHeader, contentTextView)
        
        tagSectionView.addArrangedSubviews(tagViewHeader, tagStackView)
        
        contentTextView.addSubview(placeholderLabel)
        tagStackView.addArrangedSubviews(announceButton, eventButton)
    }
    
    func setupLayout() {
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)//.inset(17)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(postButton.snp.top).offset(-10)
        }
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        imageStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        imageScrollView.snp.makeConstraints {
            $0.height.equalTo(83)  // 이미지 높이 설정
        }
        
        titleTextField.snp.makeConstraints {
            $0.height.equalTo(38)
        }
        
        selectPhotoButton.snp.makeConstraints {
            $0.size.equalTo(75)
        }
        
        postButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(48)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(17)
        }
        
        [announceButton, eventButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(28)
            }
        }
        
        announceButton.snp.makeConstraints {
            $0.width.equalTo(56)
            $0.height.equalTo(28)
        }
        
        eventButton.snp.makeConstraints {
            $0.width.equalTo(69)
            $0.height.equalTo(28)
        }

        contentTextView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(minimumTextViewHeight)
        }
        
        tagStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalTo(56 + 8 + 69)
        }
    }
    
    private func updatePhotoCount() {
        selectedImagesCount += 1  // 또는 -= 1
        selectPhotoButton.setNeedsUpdateConfiguration()
    }
    
    func addImage(_ image: UIImage) {
        
    }
    
    func setupDelegate() {

    }
    
    func presentPHPicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 10
        configuration.filter = .images
        configuration.selection = .ordered
        configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers // 현재 표시 중인 이미지들의 identifier만 전달
        
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    func createImageView(_ image: UIImage) -> UIView {
        let containerView = UIView()
        
        let imageView = UIImageView().then {
            $0.image = image
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }
        
        let deleteButton = UIButton().then {
            $0.setImage(UIImage(resource: .delete), for: .normal)
        }
        
        containerView.addSubviews(imageView, deleteButton)
        
        imageView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8)
            $0.leading.bottom.equalToSuperview()
            $0.size.equalTo(75)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(2)
            $0.size.equalTo(20)
        }
        
        deleteButton.addTarget(self, action: #selector(deleteImageButtonTapped(_:)), for: .touchUpInside)
        
        return containerView
    }
    
    @objc private func deleteImageButtonTapped(_ sender: UIButton) {
        guard let containerView = sender.superview else { return }
        
        // 삭제할 이미지의 인덱스 찾기
        if let index = imageStackView.arrangedSubviews.firstIndex(of: containerView) {
            let identifierIndex = index - 1  // selectPhotoButton을 고려한 인덱스 조정
            if identifierIndex >= 0 && identifierIndex < selectedAssetIdentifiers.count {
                // identifier 배열에서도 제거
                selectedAssetIdentifiers.remove(at: identifierIndex)
            }
            postAnnounceViewModel.removeImageData(at: index - 1)
        }

        containerView.removeFromSuperview()
        selectedImagesCount -= 1
        updateSelectPhotoButton()
    }
    
    private func updateSelectPhotoButton() {
        var config = selectPhotoButton.configuration
        var titleAttr = AttributedString("\(selectedImagesCount)/10")
        titleAttr.font = UIFont.interChips12()
        titleAttr.foregroundColor = .black30
        config?.attributedTitle = titleAttr
        selectPhotoButton.configuration = config
    }
}

extension PostAnnounceViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        results.forEach { result in
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        guard let self,
                              let image = image as? UIImage,
                              let imageData = image.jpegData(compressionQuality: 0.005) else { return }
                        
                        // 이미지 뷰 생성 및 추가
                        let imageView = self.createImageView(UIImage(data: imageData)!)
                        self.imageStackView.addArrangedSubview(imageView)
                        
                        // 카운트 증가 및 UI 업데이트
                        self.selectedImagesCount += 1
                        self.updateSelectPhotoButton()
                        
                        // 이미지 데이터 저장 (필요한 경우)
                        print("사진 용량", imageData.count)
                        self.postAnnounceViewModel.addImageData(imageData)
                    }
                }
            }
        }
    }
}

extension PostAnnounceViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        // 텍스트뷰 크기 조절
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        // 최소 높이와 계산된 높이 중 큰 값을 사용
        let newHeight = max(estimatedSize.height, minimumTextViewHeight)
        
        // 높이 제약조건 업데이트
        textViewHeightConstraint?.update(offset: newHeight)
        
        // 레이아웃 업데이트
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            // 현재 커서의 위치를 확인
            if let selectedRange = textView.selectedTextRange {
                let caretRect = textView.caretRect(for: selectedRange.end)
                let globalCaretPosition = textView.convert(caretRect, to: self.view)
                
                // 화면 하단에서 여유 공간을 뺀 위치
                let threshold = self.view.frame.height - 50 // 키보드 높이 + 여유 공간
                
                // 커서가 threshold를 넘어가면 스크롤
                if globalCaretPosition.maxY > threshold {
                    let overflow = globalCaretPosition.maxY - threshold
                    self.scrollView.setContentOffset(
                        CGPoint(
                            x: self.scrollView.contentOffset.x,
                            y: self.scrollView.contentOffset.y + overflow
                        ),
                        animated: true
                    )
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
