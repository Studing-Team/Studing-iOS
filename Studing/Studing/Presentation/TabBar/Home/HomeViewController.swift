//
//  HomeViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var homeViewModel: HomeViewModel
    private var dynamicCellHeight: CGFloat = 337
    
    weak var coordinator: HomeCoordinator?
    
    // MARK: - Combine Properties
    
    private var selectedAssociationSubject = PassthroughSubject<Int, Never>()
    private var selectedHeaderButtonSubject = PassthroughSubject<SectionType, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let refreshControl = UIRefreshControl()
    private let studingHeaderView = StudingHeaderView(type: .home)
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SectionType, AnyHashable>!
    
    // MARK: - init
    
    init(homeViewModel: HomeViewModel,
        coordinator: HomeCoordinator) {
        self.homeViewModel = homeViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.applyGradient(colors: [.loginStartGradient.withFigmaStyleAlpha(0.3), .loginEndGradient.withFigmaStyleAlpha(0.3)], direction: .topToBottom, locations: [0, 0.5])
        
        setupCollectionView()
        configureDataSource()
        applyInitialSnapshot()
        
        setupStyle()
        setupRefreshControl()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
    
        Task {
            await fetchInitialData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let customNavController = self.navigationController as? CustomAnnouceNavigationController {
            customNavController.setNavigationType(.home)
        }
    }
    
    func fetchInitialData() async {
        // 1. 초기 데이터 로딩
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.homeViewModel.getMyAssociationInfo() }
            group.addTask { await self.homeViewModel.getUnreadAssociationInfo() }
            group.addTask { await self.homeViewModel.getMyBookmarkInfo() }
            group.addTask { await self.homeViewModel.getAnnouceInfo(name: "전체") }
            group.addTask { await self.homeViewModel.getMissAnnouceInfo(name: "전체") }
        }
        
        // 2. 데이터 로딩이 완료된 후 첫 번째 association 선택
        if let associationData = self.homeViewModel.sectionDataDict[.association] as? [AssociationEntity],
           !associationData.isEmpty {
            
            self.homeViewModel.getMySections()
            self.homeViewModel.selectedAssociationTitle.send("전체")
        }
    }
}

// MARK: - Private Bind Extensions

private extension HomeViewController {
    func bindViewModel() {
        let input = HomeViewModel.Input(associationTap: selectedAssociationSubject.eraseToAnyPublisher(),
                                        headerRightButtonTap: selectedHeaderButtonSubject.eraseToAnyPublisher())
        
        let output = homeViewModel.transform(input: input)
        
        output.annouceHeaderText
            .sink { [weak self] result in
                self?.updateHeader(result)
            }
            .store(in: &cancellables)
        
        output.headerRightButtonTap
            .sink { [weak self] result in
                
                guard let result else { return }
                
                switch result.type {
                case .annouce:
                    self?.coordinator?.pushAnnouceList(result.associationName ?? "전체")
                case .bookmark:
                    self?.coordinator?.pushBookmarkList()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        homeViewModel.sectionsData
            .sink { [weak self] sectionTypes in
                print("초기 데이터 초기화")
                // 섹션 타입이 업데이트되면 스냅샷 업데이트
                self?.applyInitialSnapshot()
            }
            .store(in: &cancellables)
        
        homeViewModel.sectionUpdatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sectionType in
                guard let self = self else { return }
                
                var snapshot = self.dataSource.snapshot()
                
                self.replaceItems(for: sectionType, to: &snapshot)
            }
            .store(in: &cancellables)
    }
    
    func updateHeader(_ text: String) {
        var snapshot = dataSource.snapshot()
        if let section = snapshot.sectionIdentifiers.first(where: { $0 == .annouce }) {
            snapshot.reloadSections([section])
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}


// MARK: - Private UIColleciotn Setup Extensions

private extension HomeViewController {
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        
        // Cell 등록
        collectionView.register(MissAnnounceCollectionViewCell.self, forCellWithReuseIdentifier: MissAnnounceCollectionViewCell.className)
        collectionView.register(AssociationCollectionViewCell.self, forCellWithReuseIdentifier: AssociationCollectionViewCell.className)
        collectionView.register(AnnounceCollectionViewCell.self, forCellWithReuseIdentifier: AnnounceCollectionViewCell.className)
        collectionView.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell.className)
        collectionView.register(EmptyBookmarkCollectionViewCell.self, forCellWithReuseIdentifier: EmptyBookmarkCollectionViewCell.className)
        collectionView.register(EmptyAnnounceCollectionViewCell.self, forCellWithReuseIdentifier: EmptyAnnounceCollectionViewCell.className)
        
        // 커스텀 헤더 뷰 등록
        collectionView.register(CustomHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CustomHeaderCollectionReusableView.className)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            
            guard let sectionTypes = self.homeViewModel.sectionsData.value, sectionIndex < sectionTypes.count else { return nil }
            
            let sectionType = sectionTypes[sectionIndex]
            
            var section: NSCollectionLayoutSection
            
            switch sectionType {
            case .missAnnouce:
                section = self.createMissAnnouceSection()
            case .association:
                section = self.createAssociationSection()
            case .annouce:
                section = self.createAnnouceSection()
            case .bookmark:
                section = self.createBookmarkSection()
            case .emptyBookmark:
                section = self.createEmptyBookmarkSection()
            }
 
            return section
        }
        
        return layout
    }
    
    func createMissAnnouceSection() -> NSCollectionLayoutSection {
        // Item 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),  // 섹션 너비의 100%
            heightDimension: .absolute(105)       // 높이만 고정
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section 정의
        let section = NSCollectionLayoutSection(group: group)
        
        // 섹션에 패딩 추가
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 19, bottom: 15, trailing: 20)

        // 스크롤 비활성화 (단일 셀이므로)
        section.orthogonalScrollingBehavior = .none

        return section
    }
    
    func createAssociationSection() -> NSCollectionLayoutSection {
        // Item 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(75),
            heightDimension: .absolute(99)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
       
        // Group 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(75),
            heightDimension: .absolute(99)       // 높이만 고정
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section 정의
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        // 섹션에 패딩 추가
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 29, trailing: 20)

        // Header 추가
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)  // 헤더의 예상 높이
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        section.orthogonalScrollingBehavior = .continuous

        return section
    }
    
    func createAnnouceSection() -> NSCollectionLayoutSection {
        // Item 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .fractionalHeight(1.0)
            heightDimension: .estimated(dynamicCellHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        // Group 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),  // 섹션 너비의 100%
            heightDimension: .estimated(dynamicCellHeight)       // 높이만 고정 337
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        // Section 정의
        let section = NSCollectionLayoutSection(group: group)
        
        // 섹션에 패딩 추가
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 39, trailing: 20)

        // Header 추가
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)  // 헤더의 예상 높이
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]

        section.orthogonalScrollingBehavior = .groupPagingCentered

        return section
    }
    
    func createBookmarkSection() -> NSCollectionLayoutSection {
        // Item 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(201),
            heightDimension: .absolute(135)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)

        // Group 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(201),
            heightDimension: .absolute(135)       // 높이만 고정
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        // Section 정의
        let section = NSCollectionLayoutSection(group: group)
        
        // 섹션에 패딩 추가
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 50, trailing: 20)

        // Header 추가
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)  // 헤더의 예상 높이
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        section.orthogonalScrollingBehavior = .continuous

        return section
    }
    
    func createEmptyBookmarkSection() -> NSCollectionLayoutSection {
        // Item 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),  // 섹션 너비의 100%
            heightDimension: .absolute(135)       // 높이만 고정
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        // Section 정의
        let section = NSCollectionLayoutSection(group: group)
        
        // 섹션에 패딩 추가
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 50, trailing: 20)

        // Header 추가
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)  // 헤더의 예상 높이
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        section.orthogonalScrollingBehavior = .none

        return section
    }

    func createEmptyAnnouceSection() -> NSCollectionLayoutSection {
        // Item 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),  // 섹션 너비의 100%
            heightDimension: .absolute(201)       // 높이만 고정
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        // Section 정의
        let section = NSCollectionLayoutSection(group: group)
        
        // 섹션에 패딩 추가
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 50, trailing: 20)

        // Header 추가
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)  // 헤더의 예상 높이
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        section.orthogonalScrollingBehavior = .none

        return section
    }
}

// MARK: - UIColleciotn Delegate Extensions

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = homeViewModel.sectionsData.value?[indexPath.section] else { return }
        
        switch sectionType {
        case .missAnnouce:
            self.coordinator?.pushDetailAnnouce(type: .unreadAnnounce, selectedAssociationType: homeViewModel.selectedAssociationType)
            
        case .association:
            selectedAssociationSubject.send(indexPath.row)
        default:
            break
        }
    }
}

// MARK: - Private UIColleciotn DataSource Extensions

private extension HomeViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionType, AnyHashable>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            guard let sectionType = self.homeViewModel.sectionsData.value?[indexPath.section] else { return nil }
            
            switch sectionType {
            case .missAnnouce:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissAnnounceCollectionViewCell.className, for: indexPath) as! MissAnnounceCollectionViewCell
                if let model = item as? MissAnnounceEntity {
                    cell.configureCell(forModel: model)
                }
                return cell
                
            case .association:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssociationCollectionViewCell.className, for: indexPath) as! AssociationCollectionViewCell
                if let model = item as? AssociationEntity {
                    cell.configureCell(forModel: model)
                }
                return cell
                
            case .annouce:
                if let items = self.homeViewModel.sectionDataDict[.annouce],
                   !items.isEmpty {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnnounceCollectionViewCell.className, for: indexPath) as! AnnounceCollectionViewCell
                    if let model = item as? AssociationAnnounceEntity {
                        self.dynamicCellHeight = 337
                        cell.configureCell(forModel: model)
                    }
                    return cell
                } else {
                    // 데이터가 없을 때는 빈 상태 셀 반환
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyAnnounceCollectionViewCell.className, for: indexPath) as! EmptyAnnounceCollectionViewCell
                    self.dynamicCellHeight = 201
                    return cell
                }
                
            case .bookmark:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.className, for: indexPath) as! BookmarkCollectionViewCell
                if let model = item as? BookmarkAnnounceEntity {
                    cell.configureCell(forModel: model)
                }
                
                return cell
                
            case .emptyBookmark:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyBookmarkCollectionViewCell.className, for: indexPath) as! EmptyBookmarkCollectionViewCell
                
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            // sectionsData의 현재 값에 접근하고, 값이 nil이 아닌지 확인
            guard let sections = self?.homeViewModel.sectionsData.value,
                  indexPath.section < sections.count else {
                return nil
            }
            
            // 섹션 타입 가져오기
            let sectionType = sections[indexPath.section]
            
            // 헤더를 dequeue할 때 타입 명시
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomHeaderCollectionReusableView.className,
                for: indexPath
            ) as? CustomHeaderCollectionReusableView
            
            // 헤더가 성공적으로 dequeue되었는지 확인
            guard let header = header else { return nil }
            
            // 버튼 탭 핸들러를 먼저 설정 (중요!)
            if sectionType == .annouce || sectionType == .bookmark {
                header.rightButtonTapped = { [weak self] in
                    self?.selectedHeaderButtonSubject.send(sectionType)
                }
            } else {
                header.rightButtonTapped = nil
            }
            
            
            // 각 섹션별로 헤더 내용 설정
            switch sectionType {
            case .association:
                header.configureHeader(type: .association, headerTitle: "서울과학기술대학교")
                
            case .annouce:
                header.configureHeader(type: .annouce, headerTitle: self?.homeViewModel.selectedAssociationTitle.value ?? "")
                
            case .bookmark:
                header.configureHeader(type: .bookmark, headerTitle: "상우")
                
            case .emptyBookmark:
                header.configureHeader(type: .emptyBookmark, headerTitle: "")
                
            default:
                break
            }
            
            return header
        }
    }
    
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, AnyHashable>()
        
        guard let sections = homeViewModel.sectionsData.value else { return }
        print("섹션 만들어라", sections)
        for section in sections {
            snapshot.appendSections([section])
            
            // 섹션 타입에 따라 아이템을 추가하는 로직을 공통 함수로 처리
            appendItems(for: section, to: &snapshot)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func appendItems(for section: SectionType, to snapshot: inout NSDiffableDataSourceSnapshot<SectionType, AnyHashable>) {
        switch section {
        case .missAnnouce:
            guard let items = homeViewModel.sectionDataDict[section] else { return }
            
            let missAnnounceItems = items.compactMap { $0 as? MissAnnounceEntity }
            snapshot.appendItems(missAnnounceItems, toSection: section)
            print("놓친 공지사항 섹션 업데이트!")
            
        case .association:
            guard let items = homeViewModel.sectionDataDict[section] else { return }
            
            let associationItems = items.compactMap { $0 as? AssociationEntity }
            snapshot.appendItems(associationItems, toSection: section)
            print("학생회 리스트 섹션 업데이트!")
            
        case .annouce:
            if let items = homeViewModel.sectionDataDict[section],
               !items.isEmpty {
                let annouceItems = items.compactMap { $0 as? AssociationAnnounceEntity }
                snapshot.appendItems(annouceItems, toSection: section)
                print("최근 공지사항 리스트 섹션 업데이트!")
            } else {
                print("최근 공지사항 비어있는 리스트 섹션 업데이트!")
            }
            
        case .bookmark:
            guard let items = homeViewModel.sectionDataDict[section] else { return }
            
            let bookmarkItems = items.compactMap { $0 as? BookmarkAnnounceEntity }
            snapshot.appendItems(bookmarkItems, toSection: section)
            print("저장한 공지 섹션 업데이트!")
            
        case .emptyBookmark:
            snapshot.appendItems([EmptyBookmarkModel()], toSection: section)
            print("저장한 공지 없는 섹션 업데이트!")
        }
    }
    
    func replaceItems(for sectionType: SectionType, to snapshot: inout NSDiffableDataSourceSnapshot<SectionType, AnyHashable>) {
        guard let items = homeViewModel.sectionDataDict[sectionType] else { return }
        
        // 새로 추가할 아이템들
        let newItems: [AnyHashable]
        
        switch sectionType {
        case .association:
            newItems = items.compactMap { $0 as? AssociationEntity }
        case .missAnnouce:
            newItems = items.compactMap { $0 as? MissAnnounceEntity }
        case .annouce:
            if items.isEmpty {
                newItems = [EmptyAnnonuceModel()]
            } else {
                newItems = items.compactMap { $0 as? AssociationAnnounceEntity }
            }
        case .bookmark:
            newItems = items.compactMap { $0 as? BookmarkAnnounceEntity }
        case .emptyBookmark:
            newItems = [EmptyBookmarkModel()]
        }
        
        // 해당 섹션의 기존 아이템을 삭제
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: sectionType))
        
        // 새 아이템을 해당 섹션에 추가
        snapshot.appendItems(newItems, toSection: sectionType)
        
        // 변경된 내용만 반영 (애니메이션을 통해)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Private View SetUp Extensions

private extension HomeViewController {
    func setupStyle() {
        collectionView.do {
            $0.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(collectionView)
    }
    
    func setupLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setupRefreshControl() {
        refreshControl.tintColor = .primary50  // 로딩 인디케이터 색상
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    func setupDelegate() {
        collectionView.delegate = self
    }
    
    @objc private func handleRefresh() {
        Task {
            // 데이터 새로고침
            await fetchInitialData()
            // UI 업데이트는 메인 스레드에서
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
}
