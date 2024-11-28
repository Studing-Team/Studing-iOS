//
//  AnnouceListViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import Combine
import UIKit

import SnapKit
import Then

enum AnnounceListType {
    case association
    case bookmark
}

enum AnnounceSectionType: CaseIterable {
    case association
    case annouceList
}

enum BottomSectionItem: Hashable {
    case association(AllAssociationAnnounceListEntity)
    case allAnnounce(AllAnnounceEntity)
    case bookmark(BookmarkListEntity)
    case emptyAssociation
    case emptyBookmark
}

final class AnnounceListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var assicationName: String? // 뷰 초기화 시 필요한 assication
    private var selectedAssociationIndexSubject = PassthroughSubject<Int, Never>()
    private var refreshAnnounceListSubject = PassthroughSubject<Void, Never>()
    
    private let announceViewModel: AnnounceListViewModel
    private var type: AnnounceListType
    weak var coordinator: HomeCoordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private var topDataSource: UICollectionViewDiffableDataSource<AnnounceSectionType, AssociationEntity>!
    private var bottomDataSource: UICollectionViewDiffableDataSource<AnnounceSectionType, BottomSectionItem>!
    
    // MARK: - UI Properties
    
    private let refreshControl = UIRefreshControl()
    private var topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var askStudingView = AskStudingView(type: .list)
    
    // MARK: - init
    
    init(type: AnnounceListType, assicationName: String? = nil, announceViewModel: AnnounceListViewModel, coordinator: HomeCoordinator) {
        self.type = type
        self.assicationName = assicationName
        self.announceViewModel = announceViewModel
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
        
        setupStyle()
        setupRefreshControl()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupCollectionView()
        configureDataSource()
        
        Task {
            await announceViewModel.getMyAssociationInfo()
            
            // type에 따른 데이터 요청
            switch type {
            case .association:
                if assicationName == "전체" {
                    selectedAssociationIndexSubject.send(0)
                } else {
                    Task {
                        let index = Int(announceViewModel.associationsSubject.value.firstIndex(where: { $0.associationType?.typeName == assicationName }) ?? 0)
                        
                        selectedAssociationIndexSubject.send(index)
                    }
                }
            case .bookmark:
                Task {
                    await withTaskGroup(of: Void.self) { group in
                        group.addTask { await self.announceViewModel.fetchAssociationInitialData(name: "전체") }
                        group.addTask { await self.announceViewModel.postBookmarkAssociationAnnounceList(name: "전체") }
                    }
                    
                    selectedAssociationIndexSubject.send(0)
                }
            }
        }
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let customNavController = self.navigationController as? CustomAnnouceNavigationController {
            
            customNavController.setNavigationType(type == .association ? .announce : .bookmark)
        }
    }
}

private extension AnnounceListViewController {
    /// 상단 CollectionView Snapshot
    func updateAssociationSnapshot(with associations: [AssociationEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<AnnounceSectionType, AssociationEntity>()
        snapshot.appendSections([.association])
        snapshot.appendItems(associations)
        topDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    /// 하단 CollectionView Snapshot
    func updateBottomSnapshot(with items: [BottomSectionItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<AnnounceSectionType, BottomSectionItem>()
        snapshot.appendSections([.annouceList])
        snapshot.appendItems(items)
        bottomDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureDataSource() {
        // 상단 CollectionView DataSource
        topDataSource = UICollectionViewDiffableDataSource<AnnounceSectionType, AssociationEntity>(collectionView: topCollectionView) { collectionView, indexPath, association in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssociationCollectionViewCell.className, for: indexPath) as? AssociationCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(forModel: association)
            return cell
        }
        
        // 하단 CollectionView DataSource
        bottomDataSource = UICollectionViewDiffableDataSource(collectionView: bottomCollectionView) { [weak self] collectionView, indexPath, item in
            switch self?.type {
            case .association:
                switch item {
                case .allAnnounce(let model):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnnounceListCollectionViewCell.className, for: indexPath) as? AnnounceListCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.configureCell(forModel: model)
                    return cell
                    
                case .association(let model):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnnounceListCollectionViewCell.className, for: indexPath) as? AnnounceListCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.configureCell(forModel: model)
                    return cell
                    
                case .emptyAssociation:
                    
                    let isRegistered = self?.announceViewModel.associationsSubject.value
                        .first(where: { $0.isSelected })?
                        .isRegisteredDepartment ?? false
                    
                    // 미등록 학과인 경우
                    if !isRegistered {
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnRegisteredAssociationCollectionViewCell.className, for: indexPath) as? UnRegisteredAssociationCollectionViewCell else {
                            return UICollectionViewCell()
                        }
                        
                        cell.configure(.list)
                        
                        return cell
                    } else {
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyAnnounceCollectionViewCell.className, for: indexPath) as? EmptyAnnounceCollectionViewCell else {
                            return UICollectionViewCell()
                        }
                        
                        cell.configure(.list)
                        
                        return cell
                    }
                    
                default:
                    return UICollectionViewCell()
                }
                
            case .bookmark:
                switch item {
                case .bookmark(let model):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkListCollectionViewCell.className, for: indexPath) as? BookmarkListCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.configureCell(forModel: model)
                    return cell
                    
                case .emptyBookmark:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyBookmarkListCollectionViewCell.className, for: indexPath) as? EmptyBookmarkListCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    return cell
                    
                default:
                    return UICollectionViewCell()
                }
                
            default:
                return UICollectionViewCell()
            }
        }
    }
}

private extension AnnounceListViewController {
    private func bindViewModel() {
        
        let input = AnnounceListViewModel.Input(
            associationTap: selectedAssociationIndexSubject.eraseToAnyPublisher(),
            refreshAction: refreshAnnounceListSubject.eraseToAnyPublisher()
        )
        
        let output = announceViewModel.transform(input: input)
        
        // Snapshot 업데이트를 위한 바인딩
        output.associations
            .sink { [weak self] associations in
                self?.updateAssociationSnapshot(with: associations)
            }
            .store(in: &cancellables)
            
        // type에 따라 다른 데이터 바인딩
        switch type {
        case .association:
            // 전체 공지사항 구독
            output.allAnnounce
                .sink { [weak self] announces in
                    let items = announces.isEmpty ?
                        [.emptyAssociation] :
                        announces.map { BottomSectionItem.allAnnounce($0) }
                    self?.updateBottomSnapshot(with: items)
                }
                .store(in: &cancellables)
                
            // 학회별 공지사항 구독
            output.anthoerAnnounces
                .sink { [weak self] announces in
                    let items = announces.isEmpty ?
                        [.emptyAssociation] :
                        announces.map { BottomSectionItem.association($0) }
                    self?.updateBottomSnapshot(with: items)
                }
                .store(in: &cancellables)
            
        case .bookmark:
            output.bookmarks
                .sink { [weak self] bookmarks in
                    let items = bookmarks.isEmpty ? [.emptyBookmark] : bookmarks.map { BottomSectionItem.bookmark($0) }
                    self?.updateBottomSnapshot(with: items)
                }
                .store(in: &cancellables)
        }
        
        output.refreshResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
    }

    func setupStyle() {
        topCollectionView.do {
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal  // 가로 스크롤 설정
            
            $0.collectionViewLayout = layout
        }
        
        bottomCollectionView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    func setupRefreshControl() {
        refreshControl.tintColor = .primary50  // 로딩 인디케이터 색상
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        bottomCollectionView.refreshControl = refreshControl
    }
    
    @objc func handleRefresh() {
        refreshAnnounceListSubject.send()

    }
    
    func setupHierarchy() {
        switch type {
        case .association:
            view.addSubviews(topCollectionView, askStudingView, bottomCollectionView)
            
        case .bookmark:
            view.addSubviews(topCollectionView, bottomCollectionView)
        }
    }
    
    func setupLayout() {
        topCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(113)
        }
            
        if type == .association {
            askStudingView.snp.makeConstraints {
                $0.top.equalTo(topCollectionView.snp.bottom)
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
            
            bottomCollectionView.snp.makeConstraints {
                $0.top.equalTo(askStudingView.snp.bottom).offset(25)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview()
            }
        } else {
            bottomCollectionView.snp.makeConstraints {
                $0.top.equalTo(topCollectionView.snp.bottom).offset(11)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview()
            }

        }
    }
    
    func setupDelegate() {
        topCollectionView.delegate = self
        bottomCollectionView.delegate = self
    }
    
    func setupCollectionView() {
        topCollectionView.register(AssociationCollectionViewCell.self, forCellWithReuseIdentifier: AssociationCollectionViewCell.className)
        
        switch type {
        case .association:
            bottomCollectionView.register(AnnounceListCollectionViewCell.self, forCellWithReuseIdentifier: AnnounceListCollectionViewCell.className)
            
            bottomCollectionView.register(EmptyAnnounceCollectionViewCell.self, forCellWithReuseIdentifier: EmptyAnnounceCollectionViewCell.className)
            
            bottomCollectionView.register(UnRegisteredAssociationCollectionViewCell.self, forCellWithReuseIdentifier: UnRegisteredAssociationCollectionViewCell.className)
            
        case .bookmark:
            bottomCollectionView.register(BookmarkListCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkListCollectionViewCell.className)
            bottomCollectionView.register(EmptyBookmarkListCollectionViewCell.self, forCellWithReuseIdentifier: EmptyBookmarkListCollectionViewCell.className)
        }
    }
}

extension AnnounceListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case topCollectionView:
            return CGSize(width: 75, height: 99)
            
        case bottomCollectionView:
            switch type {
            case .association:
                if case .emptyAssociation = bottomDataSource.itemIdentifier(for: indexPath) {
                    return CGSize(width: collectionView.bounds.width, height: 466)
                }
                
                return CGSize(width: collectionView.bounds.width, height: 154)
            case .bookmark:
                if case .emptyBookmark = bottomDataSource.itemIdentifier(for: indexPath) {
                    return CGSize(width: collectionView.bounds.width, height: 466)
                }
                return CGSize(width: collectionView.bounds.width, height: 100)
            }
            
        default:
            return .zero
        }
    }
    
    /// 같은 행 또는 열에 있는 아이템들 사이의 최소 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case topCollectionView:
            return 10
        case bottomCollectionView:
            return 4
        default:
            return 0
        }
    }
    
    /// 섹션의 전체 여백(padding) 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch collectionView {
        case topCollectionView:
            return UIEdgeInsets(top: 0, left: 19, bottom: 14, right: 16)
        case bottomCollectionView:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

extension AnnounceListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case topCollectionView:
//            let data = announceViewModel.associationsSubject.value[indexPath.row]
            selectedAssociationIndexSubject.send(indexPath.row)
            
        case bottomCollectionView:
            
            guard let item = bottomDataSource.itemIdentifier(for: indexPath) else { return }
            
            
            switch item {
            case .association:
                let data = announceViewModel.associationAnnouncesSubject.value[indexPath.row]
                
                coordinator?.pushDetailAnnouce(type: .announce, announceId: data.announceId)
                
            case .allAnnounce:
                let data = announceViewModel.allAnnouncesSubject.value[indexPath.row]
                
                coordinator?.pushDetailAnnouce(type: .announce, announceId: data.announceId)
            case .bookmark:
                
                let data = announceViewModel.bookmarkListSubject.value[indexPath.row]
                
                coordinator?.pushDetailAnnouce(type: .bookmarkAnnounce, announceId: data.bookmarkId)
            case .emptyAssociation, .emptyBookmark:
                // empty 셀은 아무 동작 하지 않음
                return
            }
        default:
            break
        }
    }
}
