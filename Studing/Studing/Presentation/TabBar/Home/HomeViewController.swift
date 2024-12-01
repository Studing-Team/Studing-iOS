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
    
    private var userAuth: UserAuth
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
    
    private lazy var unUserAuthView: UnUserAuthView? = {
        switch userAuth {
        case .unUser, .failureUser:
            return UnUserAuthView(userAuth: userAuth)
        default:
            return nil
        }
    }()
    
    private var collectionView: UICollectionView!
    private let askStudingView = AskStudingView(type: .home)
    private lazy var postButton = UIButton()
    
    private var dataSource: UICollectionViewDiffableDataSource<SectionType, AnyHashable>!
    
    // MARK: - init
    
    init(homeViewModel: HomeViewModel,
         coordinator: HomeCoordinator,
         userAuth: UserAuth) {
        self.homeViewModel = homeViewModel
        self.coordinator = coordinator
        self.userAuth = userAuth
        
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
        
        view.applyGradient(colors: [.loginStartGradient.withFigmaStyleAlpha(0.3), .loginEndGradient.withFigmaStyleAlpha(0.3)], direction: .topToBottom, locations: [0, 0.5])
        
        homeLayoutForUserAuth()
        
        // userAuth 업데이트 옵저버
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userAuthDidUpdate),
            name: .userAuthDidUpdate,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("HomeViewController viewWillAppear")
        
        if let customNavController = self.navigationController as? CustomAnnouceNavigationController {
            customNavController.interactivePopGestureRecognizer?.isEnabled = true
        }
        
        if let customNavController = self.navigationController as? CustomAnnouceNavigationController {
            customNavController.setNavigationType(.home)
        }
        
        switch userAuth {
        case .collegeUser, .departmentUser, .universityUser, .successUser:
            Task {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask {
                        await self.homeViewModel.getMissAnnouceInfo(name: "전체")
                        await self.homeViewModel.getUnreadAssociationInfo()
                        await self.homeViewModel.getMyAssociationInfo()
                        await self.homeViewModel.getAnnouceInfo(name: self.homeViewModel.selectedAssociationType)
                        await self.homeViewModel.getMyBookmarkInfo()
                    }
                }
                
                self.homeViewModel.getMySections()
            }
        case .failureUser, .unUser:
            let userAuthData = KeychainManager.shared.loadData(key: .userAuthState, type: String.self).flatMap { UserAuth(rawValue: $0) } ?? .unUser
            print("HomeViewController viewWillAppear:", userAuthData)
            if userAuthData != userAuth {
                print("학생 권한이 바뀌었습니다", userAuth, userAuthData)
                userAuth = userAuthData
                updateUnUserAuthView()
            }
        }
    }
    
    func fetchInitialData() async {
        // 1. 초기 데이터 로딩
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.homeViewModel.getUnreadAssociationInfo()
                await self.homeViewModel.getMyAssociationInfo()
            }

            group.addTask { await self.homeViewModel.getMyBookmarkInfo() }
            group.addTask { await self.homeViewModel.getAnnouceInfo(name: self.homeViewModel.selectedAssociationType) }
            group.addTask { await self.homeViewModel.getMissAnnouceInfo(name: self.homeViewModel.selectedAssociationType) }
        }

        // 2. 데이터 로딩이 완료된 후 첫 번째 association 선택
        if let associationData = self.homeViewModel.sectionDataDict[.association] as? [AssociationEntity],
           !associationData.isEmpty {
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                let index = associationData.firstIndex(where: { $0.associationType?.typeName == self.homeViewModel.selectedAssociationType })
                
                self.selectedAssociationSubject.send(index ?? 0)
                self.homeViewModel.getMySections()
            }
        }
    }
    
    func updateUnUserAuthView() {
        // UI 업데이트를 메인 스레드에서 강제 실행
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 기존 unUserAuthView 제거
            self.unUserAuthView?.removeFromSuperview()
            
            // 새로운 unUserAuthView 생성 및 추가
            self.unUserAuthView = UnUserAuthView(userAuth: self.userAuth)
            if let unUserAuthView = self.unUserAuthView {
                self.view.addSubview(unUserAuthView)
                
                // unUserAuthView의 레이아웃만 다시 설정
                unUserAuthView.snp.makeConstraints {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                        .offset(self.view.convertByHeightRatio(self.userAuth == .unUser ? 192.5 : 156))
                    $0.centerX.equalToSuperview()
                    $0.horizontalEdges.equalToSuperview()
                    $0.bottom.equalTo(self.askStudingView.snp.top)
                        .inset(self.view.convertByHeightRatio(self.userAuth == .unUser ? 199.5 : 165))
                }
                
                if case .failureUser = self.userAuth {
                    unUserAuthView.buttonTapped
                        .sink { [weak self] _ in
                            self?.coordinator?.pushToReSubmit()
                        }
                        .store(in: &self.cancellables)
                }
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func userAuthDidUpdate(_ notification: Notification) {
        print("userAuthDidUpdate 실행")
        if let userAuth = notification.userInfo?["userAuth"] as? UserAuth {
            // userAuth 업데이트 처리
            print("업데이트 받은 데이터:", userAuth)
            
            let oldAuth = self.userAuth
            self.userAuth = userAuth
            
            KeychainManager.shared.saveData(key: .userAuthState, value: userAuth.rawValue)
            
            // 이전 상태가 unUser나 failureUser였고, 새로운 상태가 그 외의 상태로 변경된 경우
            if (oldAuth == .unUser || oldAuth == .failureUser) &&
                (userAuth != .unUser && userAuth != .failureUser) {
                coordinator?.comfirmAuthUser()
            } else {
                switch userAuth {
                case .collegeUser, .departmentUser, .universityUser, .successUser:
                    Task {
                        await homeViewModel.getMissAnnouceInfo(name: homeViewModel.selectedAssociationType)
                        self.homeViewModel.getMySections()
                    }
                case .failureUser, .unUser:
                    updateUnUserAuthView()
                }
            }
        }
    }
}

// MARK: - Private Bind Extensions

private extension HomeViewController {
    func bindViewModel() {
        let input = HomeViewModel.Input(
            associationTap: selectedAssociationSubject.eraseToAnyPublisher(),
            headerRightButtonTap: selectedHeaderButtonSubject.eraseToAnyPublisher(),
            postButtonTap: postButton.tapPublisher.eraseToAnyPublisher())
        
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
        
        output.postButtonTap
            .sink { [weak self] _ in
                self?.coordinator?.presentPostAnnounce()
            }
            .store(in: &cancellables)
        
        homeViewModel.sectionsData
            .sink { [weak self] sectionTypes in
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
    
    func homeLayoutForUserAuth() {
        if case .failureUser = userAuth {
            unUserAuthView?.buttonTapped
                .sink { [weak self] _ in
                    self?.coordinator?.pushToReSubmit()
                }
                .store(in: &cancellables)
        }

        switch userAuth {
        case .unUser, .failureUser:
            setupHierarchy()
            setupLayout()
            
        case .successUser, .universityUser, .collegeUser, .departmentUser:
            setupCollectionView()
            configureDataSource()
            applyInitialSnapshot()
            
            setupStyle()
            
            setupHierarchy()
            setupLayout()
            
            setupRefreshControl()
            setupDelegate()
            bindViewModel()
        
            Task {
                await fetchInitialData()
            }
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
        collectionView.register(EmptyMissAnnounceCell.self, forCellWithReuseIdentifier: EmptyMissAnnounceCell.className)
        collectionView.register(UnRegisteredAssociationCollectionViewCell.self, forCellWithReuseIdentifier: UnRegisteredAssociationCollectionViewCell.className)
        
        // 커스텀 헤더 뷰 등록
        collectionView.register(CustomHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CustomHeaderCollectionReusableView.className)
        
        collectionView.register(PageFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: PageFooterView.className)
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
            heightDimension: .estimated(max(201, dynamicCellHeight)) //.estimated(dynamicCellHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        // Group 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),  // 섹션 너비의 100%
            heightDimension: .estimated(max(201, dynamicCellHeight)) // 높이만 고정 337
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        // Section 정의
        let section = NSCollectionLayoutSection(group: group)
        
        // 섹션에 패딩 추가
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 0, trailing: 20)

        // Header 추가
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)  // 헤더의 예상 높이
        )
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)  // 헤더의 예상 높이
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        section.boundarySupplementaryItems = [header, footer]

        section.orthogonalScrollingBehavior = .groupPagingCentered

        // visibleItemsInvalidationHandler에서는 currentPage만 업데이트
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, contentOffset, environment) in
            let pageWidth = environment.container.contentSize.width
            let currentPage = Int(ceil(contentOffset.x / pageWidth))
            
            print("현재 페이지:", currentPage)
            
            if let footerView = self?.collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionFooter)
                .first(where: { $0 is PageFooterView }) as? PageFooterView {
                footerView.currentPage = currentPage - 1
            }
        }

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
            self.coordinator?.pushDetailAnnouce(type: .unreadAnnounce, selectedAssociationType: "전체", unReadCount: homeViewModel.unReadCount)
            
        case .association:
            selectedAssociationSubject.send(indexPath.row)
            
        case .annouce:
            // 선택된 학과의 등록 여부 확인
            let isRegistered = (homeViewModel.sectionDataDict[.association] as? [AssociationEntity])?
                .first(where: { $0.isSelected })?
                .isRegisteredDepartment ?? false
            
            // 등록된 학과일 때만 상세 화면으로 이동
            if isRegistered && !(homeViewModel.sectionDataDict[.annouce]?.isEmpty ?? true)  {
                guard let data = homeViewModel.sectionDataDict[.annouce] else { return }
                guard let entity = data[indexPath.row] as? AssociationAnnounceEntity else { return }
                
                coordinator?.pushDetailAnnouce(type: .announce, announceId: entity.announceId)
            }

        case .bookmark:
            guard let data = homeViewModel.sectionDataDict[.bookmark] else { return }
            guard let entity = data[indexPath.row] as? BookmarkAnnounceEntity else { return }
            
            coordinator?.pushDetailAnnouce(type: .bookmarkAnnounce, announceId: entity.bookmarkId)
            
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
                
                // 먼저 선택된 학과의 등록 여부 확인
                let isRegistered = (self.homeViewModel.sectionDataDict[.association] as? [AssociationEntity])?
                        .first(where: { $0.isSelected })?
                        .isRegisteredDepartment ?? false
                
                // 미등록 학과인 경우
                if !isRegistered {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnRegisteredAssociationCollectionViewCell.className, for: indexPath) as! UnRegisteredAssociationCollectionViewCell
                    self.dynamicCellHeight = 201
                    cell.configure(.home)  // 미등록 상태
                    return cell
                }

                // 등록된 학과이면서 데이터가 있는 경우
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
                    
                    cell.configure(.home)
                    
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
                
                cell.allAnnounceButtonAction = { [weak self] in
                    self?.coordinator?.pushAnnouceList("전체")
                }
                
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let sections = self?.homeViewModel.sectionsData.value,
                  indexPath.section < sections.count else {
                return nil
            }
            
            let sectionType = sections[indexPath.section]
            
            // Header 처리
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CustomHeaderCollectionReusableView.className,
                    for: indexPath
                ) as? CustomHeaderCollectionReusableView
                
                // 헤더가 성공적으로 dequeue되었는지 확인
                guard let header = header else { return nil }
                
                // 버튼 탭 핸들러를 먼저 설정
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
                    let universityName = KeychainManager.shared.loadData(key: .userInfo, type: UserInfo.self)?.university ?? "알수없음"
                    header.configureHeader(type: .association, headerTitle: universityName)
                    
                case .annouce:
                    header.configureHeader(type: .annouce, headerTitle: self?.homeViewModel.selectedAssociationTitle.value ?? "")
                    
                case .bookmark:
                    let userName = KeychainManager.shared.loadData(key: .userInfo, type: UserInfo.self)?.userName ?? "알수없음"
                    header.configureHeader(type: .bookmark, headerTitle: userName)
                    
                case .emptyBookmark:
                    header.configureHeader(type: .emptyBookmark, headerTitle: "")
                    
                default:
                    break
                }
                
                return header
            }
            
            // Footer 처리
            else if kind == UICollectionView.elementKindSectionFooter {
                switch sectionType {
                case .annouce:
                    let footer = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: PageFooterView.className,
                        for: indexPath
                    ) as? PageFooterView
                    
                    
                    if let itemCount = self?.homeViewModel.sectionDataDict[.annouce]?.count {
                        footer?.configure(pageNumber: itemCount, type: .home)
                    }

                    return footer
                default:
                    return nil
                }
            }
            
            return nil
        }
    }
    
    @MainActor
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
                snapshot.appendItems([EmptyAnnonuceModel()], toSection: section)
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
    
    @MainActor
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
            // isRegistered 체크
            let isRegistered = (homeViewModel.sectionDataDict[.association] as? [AssociationEntity])?
                .first(where: { $0.isSelected })?
                .isRegisteredDepartment ?? false
            
            if !isRegistered {
                newItems = [EmptyAnnonuceModel()]
            } else if items.isEmpty {
                newItems = [EmptyAnnonuceModel()]
            } else {
                newItems = items.compactMap { $0 as? AssociationAnnounceEntity }
            }
            
            // Footer 업데이트
            if let footer = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionFooter)
                .first(where: { $0 is PageFooterView }) as? PageFooterView {
                footer.configure(pageNumber: isRegistered ? items.count : 0, type: .home)
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
        
        postButton.do {
            $0.setImage(.edit, for: .normal)
            $0.backgroundColor = .primary50
            $0.layer.cornerRadius = 27
            $0.layer.shadowColor = UIColor.black40.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)  // 그림자 위치
            $0.layer.shadowOpacity = 0.2  // 그림자 투명도
            $0.layer.shadowRadius = 6  // 그림자 퍼짐 정도
        }
    }
    
    func setupHierarchy() {
        switch userAuth {
        case .successUser:
            view.addSubviews(collectionView)
            
        case .collegeUser, .universityUser, .departmentUser:
            view.addSubviews(collectionView, postButton)
            
        case .unUser, .failureUser:
            guard let unUserAuthView else { return }
            
            view.addSubviews(unUserAuthView, askStudingView)
        }
    }
    
    func setupLayout() {
        switch userAuth {
        case .successUser:
            collectionView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            
        case .collegeUser, .universityUser, .departmentUser:
            
            collectionView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            
            postButton.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(21)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
                $0.size.equalTo(54)
            }
            
        case .unUser, .failureUser:
            guard let unUserAuthView else { return }
            
            unUserAuthView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.convertByHeightRatio(userAuth == .unUser ? 192.5 : 156))
                $0.centerX.equalToSuperview()
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalTo(askStudingView.snp.top).inset(view.convertByHeightRatio(userAuth == .unUser ? 199.5 : 165))
            }
            
            askStudingView.snp.makeConstraints {
                $0.height.equalTo(48)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            }
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

    @objc func handleRefresh() {
        Task {
            // 데이터 새로고침
            await fetchInitialData()
            // UI 업데이트는 메인 스레드에서
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc func askStudingTapped() {
        guard let url = URL(string: StringLiterals.Web.askStuding),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}

final class EmptyMissAnnounceCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SwiftUI

// UIViewController 프리뷰
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func showPreview() -> some View {
        Preview(viewController: self)
    }
}
