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
    
    var selectedAssociationSubject = PassthroughSubject<Int, Never>()
    var selectedHeaderButtonSubject = PassthroughSubject<SectionType, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    var homeViewModel = HomeViewModel()
    
    weak var coordinator: HomeCoordinator?
    
    // MARK: - UI Properties
    
    private let studingHeaderView = StudingHeaderView(type: .home)
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SectionType, AnyHashable>!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.applyGradient(colors: [.loginStartGradient.withFigmaStyleAlpha(0.3), .loginEndGradient.withFigmaStyleAlpha(0.3)], direction: .topToBottom, locations: [0, 0.5])
        
        setupCollectionView()
        configureDataSource()
        applySnapshot()
        
        setNavigationBar()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
        
        homeViewModel.getMissAnnouce()
        homeViewModel.getMyAssociation()
        homeViewModel.getAnnouceData()
        homeViewModel.getMyBookmark()
        homeViewModel.getMySections()
        
        selectedAssociationSubject.send(0)
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
            .sink { [weak self] type in
                switch type {
                case .annouce:
                    self?.coordinator?.pushDetailAnnouce()
                case .bookmark:
                    self?.coordinator?.pushDetailBookmarkAnnouce()
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        homeViewModel.sectionsData
            .sink { [weak self] sectionTypes in
                // 섹션 타입이 업데이트되면 스냅샷 업데이트
                self?.applySnapshot()
            }
            .store(in: &cancellables)
    }
    
    func updateHeader(_ text: String) {
        var snapshot = dataSource.snapshot()
        if let section = snapshot.sectionIdentifiers.first(where: { $0 == .annouce }) {
            snapshot.reloadSections([section])
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

// MARK: - Private Extensions

private extension HomeViewController {
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        
        // Cell 등록
        collectionView.register(MissAnnounceCollectionViewCell.self, forCellWithReuseIdentifier: MissAnnounceCollectionViewCell.className)
        collectionView.register(AssociationCollectionViewCell.self, forCellWithReuseIdentifier: AssociationCollectionViewCell.className)
        collectionView.register(AnnouceCollectionViewCell.self, forCellWithReuseIdentifier: AnnouceCollectionViewCell.className)
        collectionView.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell.className)
        collectionView.register(EmptyBookmarkCollectionViewCell.self, forCellWithReuseIdentifier: EmptyBookmarkCollectionViewCell.className)
        
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 29, trailing: 20)

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
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        // Group 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),  // 섹션 너비의 100%
            heightDimension: .absolute(337)       // 높이만 고정
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
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionType, AnyHashable>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            guard let sectionType = self.homeViewModel.sectionsData.value?[indexPath.section] else { return nil }
            
            switch sectionType {
            case .missAnnouce:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissAnnounceCollectionViewCell.className, for: indexPath) as! MissAnnounceCollectionViewCell
                if let model = item as? MissAnnounceModel {
                    cell.configureCell(forModel: model)
                }
                return cell
            
            case .association:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssociationCollectionViewCell.className, for: indexPath) as! AssociationCollectionViewCell
                if let model = item as? AssociationModel {
                    cell.configureCell(forModel: model)
                }
                return cell
                
            case .annouce:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnnouceCollectionViewCell.className, for: indexPath) as! AnnouceCollectionViewCell
                if let model = item as? AssociationAnnounceModel {
                    cell.configureCell(forModel: model)
                }
                return cell
                
            case .bookmark:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.className, for: indexPath) as! BookmarkCollectionViewCell
                if let model = item as? BookmarkModel {
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
            
            // 각 섹션별로 헤더 내용 설정
            switch sectionType {
            case .association:
                header.configureHeader(type: .association, headerTitle: "서울과학기술대학교")
                
            case .annouce:
                header.configureHeader(type: .annouce, headerTitle: self?.homeViewModel.selectedAssociationTitle.value ?? "")
                header.rightButtonTapped = {
                    self?.selectedHeaderButtonSubject.send(.annouce)
                }
                
            case .bookmark:
                header.configureHeader(type: .bookmark, headerTitle: "상우")
                
                header.rightButtonTapped = {
                    self?.selectedHeaderButtonSubject.send(.bookmark)
                }
                
            case .emptyBookmark:
                header.configureHeader(type: .emptyBookmark, headerTitle: "")
                
            default:
                break
            }

            return header
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, AnyHashable>()
        
        guard let sections = homeViewModel.sectionsData.value else { return }
        
        for section in sections {
            snapshot.appendSections([section])
            
            // 각 섹션 타입에 따라 적절한 모델 객체를 생성하고 추가
            switch section {
            case .missAnnouce:
                
                guard let items = homeViewModel.sectionDataDict[section] else { return }
                let missAnnounceItems = items.compactMap { $0 as? MissAnnounceModel }
                
                snapshot.appendItems(missAnnounceItems, toSection: section)
                
            case .association:
                
                guard let items = homeViewModel.sectionDataDict[section] else { return }
                let associationItems = items.compactMap { $0 as? AssociationModel }
                
                snapshot.appendItems(associationItems, toSection: section)
                
            case .annouce:
                
                guard let items = homeViewModel.sectionDataDict[section] else { return }
                let annouceItems = items.compactMap { $0 as? AssociationAnnounceModel }
                
                snapshot.appendItems(annouceItems, toSection: section)
                
            case .bookmark:
                
                guard let items = homeViewModel.sectionDataDict[section] else { return }
                let bookmarkItems = items.compactMap { $0 as? BookmarkModel }
                
                snapshot.appendItems(bookmarkItems, toSection: section)
                
            case .emptyBookmark:
                let items = [EmptyBookmarkModel()]

                snapshot.appendItems(items, toSection: section)
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func setupStyle() {
        collectionView.do {
            $0.allowsMultipleSelection = false
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(studingHeaderView, collectionView)
    }
    
    func setupLayout() {
        studingHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(studingHeaderView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setupDelegate() {
        collectionView.delegate = self
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = homeViewModel.sectionsData.value?[indexPath.section],
                  sectionType == .association else { return }

            selectedAssociationSubject.send(indexPath.row)
    }
}
