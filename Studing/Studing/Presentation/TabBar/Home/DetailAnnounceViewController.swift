//
//  DetailAnnouceViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/5/24.
//

import Combine
import UIKit

import SnapKit
import Then

enum ViewLifeCycleEvent {
    case viewDidLoad
    case viewWillAppear
}

enum DetailAnnounceType {
    case bookmarkAnnounce
    case announce
    case unreadAnnounce
}

final class DetailAnnounceViewController: UIViewController {
    
    // MARK: - Combine Properties
    
    private let nextbuttonTapSubject = PassthroughSubject<Void, Never>()
    private let currentImagePageSubject = PassthroughSubject<Int, Never>()
    private let deleteuttonTappedSubject = PassthroughSubject<Void, Never>()
    private let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private var type: DetailAnnounceType
    private let detailAnnouceViewModel: DetailAnnouceViewModel
    private var dataSource: UICollectionViewDiffableDataSource<DetailAnnouceSectionType, AnyHashable>!
    
    weak var coordinator: HomeCoordinator?
    
    private var collectionHeight: CGFloat = 0
    
    private var chagneHeight = false
    
    private var currentImagePage = 0
    
    // MARK: - UI Properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var collectionView: UICollectionView!
    
    private let bookmarkButton = UIButton()
    private let likeButton = UIButton()
    
    private let collectionBackgroundView = UIView()
    private var hasAddedExtraHeight = false
    
    private let nextButton = UIButton()
    
    private let imageCountView = UIView()
    private let imageCountLabel = UILabel()
    
    // MARK: - init
    
    init(type: DetailAnnounceType, detailAnnouceViewModel: DetailAnnouceViewModel, coordinator: HomeCoordinator) {
        self.type = type
        self.detailAnnouceViewModel = detailAnnouceViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black5
        
        setupCollectionView()
        configureDataSource()
        
        setupStyle()
        setupHierarchy(type)
        setupLayout(type)
        setupDelegate()
        bindViewModel()
        observeDotMenuButton()
        
        print("DetailAnnounceViewController viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("DetailAnnounceViewController viewWillAppear")
        viewLifeCycleSubject.send(.viewWillAppear)
        
        /// 놓친 공지사항 관련 메서드
        if let customNavController = self.navigationController as? CustomAnnounceNavigationController {
            if type == .unreadAnnounce {
                customNavController.setNavigationTitle("\(detailAnnouceViewModel.unReadCount ?? 0)개 남음")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        print("DetailAnnounceViewController viewWillDisappear")
        cancellables.removeAll()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        print("DetailAnnounceViewController deinit")
    }
}

// MARK: - Private Extensions

private extension DetailAnnounceViewController {
    func observeDotMenuButton() {
        guard let navigationController = self.navigationController as? CustomAnnounceNavigationController else { return }
        
        navigationController.menuButtonTapped
            .sink { [weak self] type in
                guard let self else { return }
                
                switch type {
                case .edit:
                    
                    guard let content = self.detailAnnouceViewModel.announceContent else { return }
                    guard let noticeId = self.detailAnnouceViewModel.selectNoticeId() else { return }

                    let dto = EditAnnounceContent(noticeId: noticeId, title: content.title, image: content.images, content: content.content, tag: content.tag)
                    
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(handleDismiss),
                        name: Notification.Name("EditPostViewDismissed"),
                        object: nil)
                    
                    self.coordinator?.presentPostAnnounce(type: .edit, noticeId: noticeId, content: dto)
                    
                case .delete:
                    self.handleDotMenuButtonTap()
                }
            }
            .store(in: &cancellables)
    }
    
    @objc func handleDismiss() {
        viewLifeCycleSubject.send(.viewWillAppear)
    }
    
    func handleDotMenuButtonTap() {
        self.showConfirmCancelAlert(
            mainTitle: "공지사항 삭제",
            subTitle: "해당 공지사항을 삭제하시겠습니까?",
            rightButtonTitle: "삭제하기",
            leftButtonTitle: "취소",
            rightButtonHandler: {
                self.deleteuttonTappedSubject.send()
            }
        )
    }
    
    func bindViewModel() {
        let input = DetailAnnouceViewModel.Input(
            viewLifeCycleEventAction: viewLifeCycleSubject.eraseToAnyPublisher(),
            likeButtonTap: likeButton.tapPublisher,
            bookmarkButtonTap: bookmarkButton.tapPublisher,
            deleteButtonTap: deleteuttonTappedSubject.eraseToAnyPublisher(),
            nextButtonTap: nextbuttonTapSubject.eraseToAnyPublisher(),
            currentPageControlCount: currentImagePageSubject.eraseToAnyPublisher()
        )
        
        let output = detailAnnouceViewModel.transform(input: input)
        
        detailAnnouceViewModel.sectionsData
            .sink { [weak self] sectionTypes in
                // 섹션 타입이 업데이트되면 스냅샷 업데이트
                self?.applySnapshot()
                
                if sectionTypes?.firstIndex(where: { $0 == .images }) == nil {
                    DispatchQueue.main.async {
                       self?.imageCountView.isHidden = true
                       self?.imageCountLabel.isHidden = true
                   }
                }
            }
            .store(in: &cancellables)
        
        output.viewLifeCycleEventResult
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // 에러 처리
                    print("Error: \(error)")
                }
            }, receiveValue: { result in
                // 결과 처리
                print("결과: \(result)")
            })
            .store(in: &cancellables)
        
        output.authorResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
 
                if let customNavController = self.navigationController as? CustomAnnounceNavigationController {
                    customNavController.addDotMenu(result)
                }
            }
            .store(in: &cancellables)
        
        output.isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavorite in
                let image = isFavorite ? UIImage(resource: .likeButton) : UIImage(resource: .unLikeButton)
                self?.likeButton.setImage(image, for: .normal)
            }
            .store(in: &cancellables)
        
        output.isBookmark
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isBookmark in
                self?.bookmarkButton.setTitle(isBookmark == true ? "저장 취소" : "저장하기", for: .normal)
            }
            .store(in: &cancellables)
        
        output.bookmarkButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isBookmark in
                self?.showToastMessage(toastType: .bookmark(isBookmark: isBookmark))
            }
            .store(in: &cancellables)
        
        output.nextButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let response):
                    if response == true {
                        if type == .unreadAnnounce {
                            if let customNavController = self.navigationController as? CustomAnnounceNavigationController {
                                customNavController.setNavigationTitle("\(detailAnnouceViewModel.unReadCount ?? 0)개 남음")
                            }
                        }
                    } else {
                        self.coordinator?.pushAllReadAnnounce()
                    }
                case .failure:
                    break
                }
            }
            .store(in: &cancellables)
        
        output.currentPageControlCountResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                
                if let itemCount = self.detailAnnouceViewModel.sectionDataDict[.images]?.count {
                    self.imageCountLabel.text = "\(self.currentImagePage + 1)/\(itemCount)"
                }
            }
            .store(in: &cancellables)
        
        output.deleteResult
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    if let presentedVC = self.presentedViewController as? CustomAlertViewController {
                        presentedVC.dismiss(animated: false)
                    }
                    
                case .failure(_):
                    if let presentedVC = self.presentedViewController as? CustomAlertViewController {
                        presentedVC.dismiss(animated: false)
                    }
                }
            }, receiveValue: { [weak self] result in
                guard let self else { return }
                switch self.type {
                case .announce, .bookmarkAnnounce:
                    ToastMessageManager.showToastMessage(toastType: .deleteAnnounce)
                    
                    if let customNavController = self.navigationController as? CustomAnnounceNavigationController {
                        customNavController.popViewController(animated: true)
                    }
                case .unreadAnnounce:
                    nextbuttonTapSubject.send()
                }
            })
            .store(in: &cancellables)
    }
    
    func setupStyle() {
        contentView.do {
            $0.backgroundColor = .black5
            $0.layer.cornerRadius = 15
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black10.cgColor
            $0.clipsToBounds = true
        }
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .clear
        }
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
        }
        
        likeButton.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 54 / 2
            $0.layer.shadowColor = UIColor.black.cgColor  // 그림자 색상
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)  // 그림자 위치
            $0.layer.shadowOpacity = 0.1  // 그림자 투명도
            $0.layer.shadowRadius = 6  // 그림자 퍼짐 정도
        }
        
        imageCountLabel.do {
            $0.textColor = .white
            $0.font = .interCaption10()
        }
        
        imageCountView.do {
            $0.backgroundColor = .black50
            $0.layer.cornerRadius = 12
        }
        
        switch type {
        case .announce, .bookmarkAnnounce:
            bookmarkButton.do {
                $0.setTitle("저장하기", for: .normal) // 버튼의 제목 설정
                $0.setTitleColor(.white, for: .normal) // 제목 색상 설정
                $0.titleLabel?.font = .interSubtitle2() // 폰트 설정
                $0.backgroundColor = .primary50 // 배경색 설정
                $0.layer.cornerRadius = 24
            }
            
        case .unreadAnnounce:
            nextButton.do {
                $0.setTitle("다음공지", for: .normal) // 버튼의 제목 설정
                $0.setTitleColor(.white, for: .normal) // 제목 색상 설정
                $0.titleLabel?.font = .interSubtitle2() // 폰트 설정
                $0.backgroundColor = .primary50 // 배경색 설정
                $0.layer.cornerRadius = 24
                $0.addTarget(self, action: #selector(nextbuttonTap), for: .touchUpInside)
            }
            
            bookmarkButton.do {
                $0.setTitle("저장하기", for: .normal) // 버튼의 제목 설정
                $0.setTitleColor(.primary50, for: .normal) // 제목 색상 설정
                $0.titleLabel?.font = .interSubtitle2() // 폰트 설정
                $0.backgroundColor = .white // 배경색 설정
                $0.layer.cornerRadius = 24
                $0.layer.borderColor = UIColor.black10.cgColor
                $0.layer.borderWidth = 1
            }
        }
    }
    
    @objc func nextbuttonTap() {
        nextbuttonTapSubject.send()
    }
    
    func setupHierarchy(_ type: DetailAnnounceType) {
        switch type {
        case .announce, .bookmarkAnnounce:
            view.addSubviews(scrollView, likeButton, bookmarkButton)
            
        case .unreadAnnounce:
            view.addSubviews(scrollView, likeButton, nextButton, bookmarkButton)
        }

        scrollView.addSubview(contentView)
        contentView.addSubviews(collectionView, imageCountView)
        imageCountView.addSubview(imageCountLabel)
    }
    
    func setupLayout(_ type: DetailAnnounceType) {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(bookmarkButton.snp.centerY)
        }
        
        scrollView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 50, right: 0)
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)  // 가로 스크롤 방지
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(80 + 355 + 44)
        }
        
        imageCountView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.top).inset(92.5)
            $0.trailing.equalTo(collectionView.snp.trailing).inset(12.5)
            $0.width.equalTo(29)
            $0.height.equalTo(22)
        }
        
        imageCountLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(19)
            $0.bottom.equalTo(bookmarkButton.snp.top).offset(-15)
            $0.size.equalTo(54)
        }
        
        switch type {
        case .announce, .bookmarkAnnounce:
            bookmarkButton.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(15)
                $0.bottom.equalToSuperview().inset(34)
                $0.height.equalTo(48)
            }
            
        case .unreadAnnounce:
            bookmarkButton.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(15)
                $0.bottom.equalToSuperview().inset(34)
                $0.width.equalTo(view.convertByWidthRatio(167))
                $0.height.equalTo(48)
            }
            
            nextButton.snp.makeConstraints {
                $0.leading.equalTo(bookmarkButton.snp.trailing).offset(view.convertByWidthRatio(11))
                $0.trailing.equalToSuperview().inset(15)
                $0.bottom.equalToSuperview().inset(34)
                $0.width.equalTo(view.convertByWidthRatio(167))
                $0.height.equalTo(48)
            }
        }
    }
    
    func setupDelegate() {
        
    }
}

extension DetailAnnounceViewController: ContentCellDelegate {
    func contentCell(_ cell: DetailAnnouceContentCollectionViewCell, didUpdateHeight height: CGFloat) {
        
        print("입력 받은 height", height)
        
        var imageHeight = 355
        
        let isImagesEmpty = detailAnnouceViewModel.sectionDataDict[.images]?.isEmpty ?? false
        if isImagesEmpty {
            imageHeight = 0
        }
        
        let baseHeight = 80 + 44 + 16 + 10
        let totalHeight = baseHeight + imageHeight + Int(height)
        
        print("변경된 높이:", totalHeight)
        collectionView.snp.updateConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(totalHeight)
        }

        view.layoutIfNeeded()
    }
}

private extension DetailAnnounceViewController {
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        // Cell 등록
        collectionView.register(DetailAnnouceHeaderCollectionViewCell.self, forCellWithReuseIdentifier: DetailAnnouceHeaderCollectionViewCell.className)
        collectionView.register(DetailAnnouceImagesCollectionViewCell.self, forCellWithReuseIdentifier: DetailAnnouceImagesCollectionViewCell.className)
        collectionView.register(DetailAnnouceContentCollectionViewCell.self, forCellWithReuseIdentifier: DetailAnnouceContentCollectionViewCell.className)
        
        collectionView.register(PageFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: PageFooterView.className)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            
            guard let sectionTypes = self.detailAnnouceViewModel.sectionsData.value, sectionIndex < sectionTypes.count else { return nil }
            
            let sectionType = sectionTypes[sectionIndex]
            
            var section: NSCollectionLayoutSection
            
            switch sectionType {
            case .header:
                section = self.createHeaderSection()
            case .images:
                section = self.createImageSection()
            case .content:
                section = self.createContentSection()
            }
            
            return section
        }
        
        return layout
    }
    
    
    func createHeaderSection() -> NSCollectionLayoutSection {
        // Item 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),  // 섹션 너비의 100%
            heightDimension: .absolute(80)       // 높이만 고정
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section 정의
        let section = NSCollectionLayoutSection(group: group)
        

        // 스크롤 비활성화 (단일 셀이므로)
        section.orthogonalScrollingBehavior = .none

        return section
    }
    
    func createImageSection() -> NSCollectionLayoutSection {
        // Item 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),  // 섹션 너비의 100%
            heightDimension: .estimated(335)       // 높이만 고정
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)  // 헤더의 예상 높이
        )
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        // Section 정의
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [footer]
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, contentOffset, environment) in
            
            guard let self else { return }
            let count = CGFloat(self.detailAnnouceViewModel.sectionDataDict[.images]?.count ?? 0)
            
            let pageWidth = environment.container.contentSize.width / count
            let currentPage = Int(round(contentOffset.x / pageWidth))
            
            print("현재 페이지:", currentPage)
            
            if let footerView = self.collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionFooter)
                .first(where: { $0 is PageFooterView }) as? PageFooterView {
                
                self.currentImagePage = currentPage / Int(count)
                footerView.currentPage = self.currentImagePage
                currentImagePageSubject.send(currentImagePage)
            }
        }
        
        return section
    }
    
    func createContentSection() -> NSCollectionLayoutSection {
        // Item 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),  // 섹션 너비의 100%
            heightDimension: .fractionalHeight(1.0) // 높이만 고정
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section 정의
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        // 스크롤 비활성화 (단일 셀이므로)
        section.orthogonalScrollingBehavior = .none

        return section
    }
    
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<DetailAnnouceSectionType, AnyHashable>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            guard let sectionType = self.detailAnnouceViewModel.sectionsData.value?[indexPath.section] else { return nil }
            
            switch sectionType {
            case .header:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailAnnouceHeaderCollectionViewCell.className, for: indexPath) as! DetailAnnouceHeaderCollectionViewCell
                
                if let model = item as? DetailAnnouceHeaderModel {
                    cell.configureCell(forModel: model)
                }
                
                return cell
            case .images:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailAnnouceImagesCollectionViewCell.className, for: indexPath) as! DetailAnnouceImagesCollectionViewCell
                
                if let model = item as? DetailAnnouceImageModel {
                    cell.configureCell(forModel: model)
                }
                
                return cell
                
            case .content:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailAnnouceContentCollectionViewCell.className, for: indexPath) as! DetailAnnouceContentCollectionViewCell
                cell.delegate = self
                if let model = item as? DetailAnnouceContentModel {
                    cell.configureCell(forModel: model)
                }
                
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            
            guard let sections = self?.detailAnnouceViewModel.sectionsData.value,
                  indexPath.section < sections.count else {
                return nil
            }
            
            let sectionType = sections[indexPath.section]
            
            if kind == UICollectionView.elementKindSectionFooter {
                switch sectionType {
                case .images:
                    let footer = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: PageFooterView.className,
                        for: indexPath
                    ) as? PageFooterView
                    
                    if let itemCount = self?.detailAnnouceViewModel.sectionDataDict[.images]?.count {
                        footer?.configure(pageNumber: itemCount, type: .list)
                    }
                    
                    return footer

                default:
                    return nil
                }
            }
            
            return nil
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<DetailAnnouceSectionType, AnyHashable>()
        
        guard let sections = detailAnnouceViewModel.sectionsData.value else { return }
        
        for section in sections {
            snapshot.appendSections([section])
            
            // 각 섹션 타입에 따라 적절한 모델 객체를 생성하고 추가
            switch section {
                
            case .header:
                guard let items = detailAnnouceViewModel.sectionDataDict[section] else { return }
                let annouceHeaderItems = items.compactMap { $0 as? DetailAnnouceHeaderModel }
                
                snapshot.appendItems(annouceHeaderItems, toSection: section)
                
            case .images:
                guard let items = detailAnnouceViewModel.sectionDataDict[section],
                      !items.isEmpty else {
                    DispatchQueue.main.async {
                        self.imageCountView.isHidden = true
                        self.imageCountLabel.isHidden = true
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.imageCountView.isHidden = false
                    self.imageCountLabel.isHidden = false
                }
                
                let annouceImageItems = items.compactMap { $0 as? DetailAnnouceImageModel }
                snapshot.appendItems(annouceImageItems, toSection: section)
                
            case .content:
                guard let items = detailAnnouceViewModel.sectionDataDict[section] else { return }
                let annouceContentItems = items.compactMap { $0 as? DetailAnnouceContentModel }
                
                snapshot.appendItems(annouceContentItems, toSection: section)
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
