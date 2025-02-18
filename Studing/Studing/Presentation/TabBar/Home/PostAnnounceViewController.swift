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

final class PostAnnounceViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    private let selectedDateSubject = PassthroughSubject<DateComponents, Never>()
    
    // MARK: - Properties
    
    private let postType: PostType
    private let postDisplayType: PostDisplayType
    
    // 선택된 이미지의 identifier를 저장할 배열 추가
    private var selectedAssetIdentifiers: [String] = [] {
        didSet {
            print(selectedAssetIdentifiers.count)
            print(selectedAssetIdentifiers)
        }
    }
    
    private var selectedImagesCount = 0 {
        didSet {
            print(selectedImagesCount)
        }
    }
    
    private var originImagesCount = 0 {
        didSet {
            print(originImagesCount)
        }
    }
    
    private var postAnnounceViewModel: PostAnnounceViewModel
    weak var coordinator: HomeCoordinator?
    
    // 최소 높이 상수 추가
    private let minimumTextViewHeight: CGFloat = 150
    
    // 높이 제약조건을 저장할 프로퍼티
    private var textViewHeightConstraint: Constraint?

    // MARK: - UI Properties
    
    private let dateView = UICalendarView()
    
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
    
    private let periodSectionView = UIStackView()
    private var periodViewHeader: TitleSectionHeaderView
    private let periodContentView = PeriodContentView()
    
    private let personSectionView = UIStackView()
    private let personViewHeader = TitleSectionHeaderView(type: .personNumber)
    private let personContentView = PersonContentView()
    
    private let selectPhotoButton = UIButton()
    
    private let announceButton = AnnounceTagButton(buttonStyle: .announce)
    private let eventButton = AnnounceTagButton(buttonStyle: .event)
    
    private let postButton: CustomButton
    
    // MARK: - Combine Publishers Properties

    private let titleSubject = PassthroughSubject<String, Never>()
    private let contentSubject = PassthroughSubject<String, Never>()
    private let tagButtonSubject = PassthroughSubject<TagStyle, Never>()
    private let selectedImageDataSubject = CurrentValueSubject<[Data]?, Never>(nil)
    private let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - init
    
    init(
        postType: PostType,
        postDisplayType: PostDisplayType,
        postAnnounceViewModel: PostAnnounceViewModel,
        coordinator: HomeCoordinator
    ) {
        self.postType = postType
        self.postDisplayType = postDisplayType
        self.postAnnounceViewModel = postAnnounceViewModel
        self.coordinator = coordinator
        self.postButton = postType == .create ? CustomButton(buttonStyle: .postAnnounce) : CustomButton(buttonStyle: .editAnnounce)
        self.periodViewHeader = TitleSectionHeaderView(type: .period(type: postDisplayType))

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

        self.view.backgroundColor = .black5
        
        hideKeyboard()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
        setupBindings()
        
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
        
        print("PostAnnounceViewController viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if case .edit = postType {
            viewLifeCycleSubject.send(.viewWillAppear)
        }
        
        if case .firstCome = postDisplayType {
            tagButtonSubject.send(.event)
        }
        
        print("PostAnnounceViewController viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if case .edit = postType {
            NotificationCenter.default.post(name: Notification.Name("EditPostViewDismissed"), object: nil)
        }
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
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        titleSubject.send(textField.text ?? "")
    }
}

private extension PostAnnounceViewController {
    func bindViewModel() {
        let input = PostAnnounceViewModel.Input(
            viewLifeCycleEventAction: viewLifeCycleSubject.eraseToAnyPublisher(),
            selectImageButtonTap: selectPhotoButton.tapPublisher,
            bottomButtonTap: postButton.tapPublisher,
            titleText: titleSubject.eraseToAnyPublisher(),
            contentText: contentSubject.eraseToAnyPublisher(),
            tagButtonText: tagButtonSubject.eraseToAnyPublisher(),
            firstComeNumber: postDisplayType == .firstCome ?
                personContentView.textPublisher.eraseToAnyPublisher() : nil
        )
        
        let output = postAnnounceViewModel.transform(input: input)
        
        /// type 이 edit 일때
        output.viewLifeCycleEventResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] content in
                
                guard let self else { return }
                
                self.titleTextField.text = content.title
                self.contentTextView.text = content.content
                
                self.titleSubject.send(content.title)
                self.contentSubject.send(content.content)
                
                self.placeholderLabel.isHidden = true
                
                if content.tag == "공지" {
                    self.announceButton.buttonState = .select
                    self.tagButtonSubject.send(.announce)
                } else {
                    self.eventButton.buttonState = .select
                    self.tagButtonSubject.send(.event)
                }
                
                if let imageURL = content.image {
                    Task {
                        await self.loadImageData(urls: imageURL)
                    }
                }
                
                if let startDay = content.startDay, let startTime = content.startTime, let endDay =  content.endDay, let endTime = content.endTime {
                    postAnnounceViewModel.startTimeSubject.send(startTime)
                    postAnnounceViewModel.endTimeSubject.send(endTime)
                    postAnnounceViewModel.startDaySubject.send(startDay)
                    postAnnounceViewModel.endDaySubject.send(endDay)
                }
                
                if let firstComeNumber = content.firstComeNumber {
                    personContentView.bindingTitle(title: firstComeNumber)
                    postAnnounceViewModel.changePostAnnounceOptionType(optionType: .firstCome)
                } else {
                    postAnnounceViewModel.changePostAnnounceOptionType(optionType: .period)
                }
            }
            .store(in: &cancellables)
        
        output.isEnableCreateButton
            .map { $0 ? ButtonState.activate : ButtonState.deactivate }
            .assign(to: \.buttonState, on: postButton)
            .store(in: &cancellables)
        
        output.selectImageButtonTap
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.presentPHPicker(type: self.postType)
            }
            .store(in: &cancellables)
        
        output.createAnnounceResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                if result {
                    if case .edit = self?.postType {
                        ToastMessageManager.showToastMessage(toastType: .editCompletion)
                    }
                    
                    if let customNavController = self?.navigationController as? CustomAnnounceNavigationController {
                        customNavController.dismiss(animated: true)
                    }
                }
            }
            .store(in: &cancellables)
        
        output.startDayResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] startDay in
                self?.periodContentView.setPeriod(type: .startDay, text: startDay)
            }
            .store(in: &cancellables)
        
        output.startTimeResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] startTime in
                self?.periodContentView.setPeriod(type: .startTime, text: startTime)
            }
            .store(in: &cancellables)
        
        output.endDayResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] endDay in
                self?.periodContentView.setPeriod(type: .endDay, text: endDay)
            }
            .store(in: &cancellables)
        
        output.endTimeResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] endTime in
                self?.periodContentView.setPeriod(type: .endTime, text: endTime)
            }
            .store(in: &cancellables)
    }
    
    func setupBindings() {
        periodViewHeader.onCheckBoxStateChanged = { [weak self] state in
            switch state {
            case .checked:
                self?.showSomething()
                self?.postAnnounceViewModel.changePostAnnounceOptionType(optionType: .period)
            case .unchecked:
                self?.hideSomething()
                self?.postAnnounceViewModel.changePostAnnounceOptionType(optionType: .basic)
            }
        }
    }
    
    func showSomething() {
        self.periodContentView.isHidden = false
    }
    
    func hideSomething() {
        self.periodContentView.isHidden = true
    }
    
    @MainActor
    func loadImageData(urls: [String]) async {
        
        // 결과를 저장할 배열 - 옵셔널 래핑 제거
        var results: [(index: Int, view: UIView, data: Data)] = []
        
        await withTaskGroup(of: (Int, UIView?, Data?)?.self) { group in
            // 인덱스와 함께 태스크 생성
            for (index, url) in urls.enumerated() {
                group.addTask {
                    if let cachedData = ImageCacheManager.shared.data(for: url) {
                        if let image = UIImage(data: cachedData) {
                            let imageView = await self.createImageView(image)
                            return (index, imageView, cachedData)
                        }
                    }

                    if let loadedImage = await LoadImageManager.shared.loadImage(url: url, type: .postSmallImage),
                       let imageData = loadedImage.pngData() {
                        let imageView = await self.createImageView(loadedImage)
                        return (index, imageView, imageData)
                    }
                    return nil
                }
            }
            
            // 결과 수집 - 성공한 경우만 배열에 추가
            for await result in group {
                if let (index, imageView, imageData) = result,
                   let validImageView = imageView,
                   let validImageData = imageData {
                    results.append((index: index, view: validImageView, data: validImageData))
                } else {
                    print("이미지 로드 실패")
                }
            }
        }
        
        // withTaskGroup 종료 이후에 UI 업데이트
        await updateUI(with: results)
    }
    
    
    @MainActor
    private func updateUI(with results: [(index: Int, view: UIView, data: Data)]) async {
        // 인덱스로 정렬 후 UI 업데이트
        results.sorted { $0.index < $1.index }.forEach { result in
            self.postAnnounceViewModel.addImageData(result.data)
            self.imageStackView.addArrangedSubview(result.view)
            
            self.selectedImagesCount += 1
            self.originImagesCount += 1
            
            self.imageStackView.layoutIfNeeded()
        }
        
        self.updateSelectPhotoButton()
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
            $0.distribution = .fill
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
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
        
        periodSectionView.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.distribution = .fill
        }
        
        personSectionView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.distribution = .fill
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
        
        periodContentView.do {
            $0.isHidden = postDisplayType == .firstCome ? false : true
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
                                             tagSectionView,
                                             periodSectionView,
                                             personSectionView
        )
        
        imageScrollView.addSubview(imageStackView)
        
        imageStackView.addArrangedSubview(selectPhotoButton)
        
        titleSectionView.addArrangedSubviews(textFieldHeader, titleTextField)
        
        textSectionView.addArrangedSubviews(textViewHeader, contentTextView)
        
        periodSectionView.addArrangedSubviews(periodViewHeader, periodContentView)
        
        if postDisplayType == .firstCome {
            personSectionView.addArrangedSubviews(personViewHeader, personContentView)
        } else {
            tagSectionView.addArrangedSubviews(tagViewHeader, tagStackView)
            tagStackView.addArrangedSubviews(announceButton, eventButton)
        }
        
        contentTextView.addSubview(placeholderLabel)
    }
    
    func setupLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(postButton.snp.top).offset(-10)
        }
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
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

        periodContentView.snp.makeConstraints {
            $0.height.equalTo(84)
        }
        
        if postDisplayType == .firstCome {
            personContentView.snp.makeConstraints {
                $0.height.equalTo(36)
            }
        }
    }
    
    private func updatePhotoCount() {
        selectedImagesCount += 1  // 또는 -= 1
        selectPhotoButton.setNeedsUpdateConfiguration()
    }
    
    func addImage(_ image: UIImage) {
        
    }
    
    func setupDelegate() {
        periodContentView.delegate = self
        contentTextView.delegate = self
    }
    
    func presentPHPicker(type: PostType) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = type == .edit ? 10 - originImagesCount : 10
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
            let identifierIndex = index
            print("몇번째 제거?", identifierIndex)
            if identifierIndex > originImagesCount { // 새로 추가한 사진에 관한 삭제
                if identifierIndex >= 0 && identifierIndex - originImagesCount >= 0 {
                    // identifier 배열에서도 제거
                    print("제거", identifierIndex - originImagesCount - 1)
                    selectedAssetIdentifiers.remove(at: identifierIndex - originImagesCount - 1)
                }
            } else { // 기존 사진에 대한 관한 삭제
                if identifierIndex >= 0 {
                    // identifier 배열에서도 제거
                    originImagesCount -= 1
                }
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
        
        // Task의 타입을 명시적으로 지정
        let tasks: [Task<(Int, Data?), Error>] = results.enumerated().map { index, result in
            Task.init(priority: .userInitiated) {
                guard result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) else {
                    return (index, nil)
                }
                
                let (data, _) = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<(Data?, Error?), Error>) in
                    result.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                            return
                        }
                        continuation.resume(returning: (data, nil))
                    }
                }
                
                return (index, data)
            }
        }
        
        // 모든 이미지 로딩이 완료될 때까지 대기
        Task {
            var orderedImages: [(Int, Data)] = []
            
            for task in tasks {
                do {
                    let result = try await task.value
                    let (index, imageData) = result

                    guard let data = imageData else { continue }
                    orderedImages.append((index, data))
                } catch {
                    print("Error loading image: \(error)")
                    continue
                }
            }
            
            // 인덱스 순서대로 정렬
            orderedImages.sort { $0.0 < $1.0 }
            
            // UI 업데이트는 메인 스레드에서 수행
            await MainActor.run {
                for (_, imageData) in orderedImages {
                    guard let downsampledData = UIImage.downsample(
                        imageData: imageData,
                        to: ImageType.postImage.imageSize,
                        scale: UIScreen.main.scale
                    ) else { continue }
                    
                    let imageView = createImageView(UIImage(data: downsampledData)!)
                    imageStackView.addArrangedSubview(imageView)
                    selectedImagesCount += 1
                    postAnnounceViewModel.addImageData(downsampledData)
                }
                
                updateSelectPhotoButton()
            }
        }
    }
}

extension PostAnnounceViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        contentSubject.send(textView.text)
        
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

extension PostAnnounceViewController: ContentViewDelegate {
    func contentView(_ contentView: UIView, didTapAction value: Any) {
        if let type = value as? PeriodType {
            coordinator?.presentCalendarModal(type: type)
        }
    }
}
