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

enum AnnouceListType {
    case association
    case bookmark
}

enum AnnouceSectionType: CaseIterable {
    case association
    case annouceList
}

enum BottomSectionItem: Hashable {
    case association(AssociationAnnounceListModel)
    case bookmark(BookmarkModel)
}

final class AnnouceListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var selectedAnnouceSubject = PassthroughSubject<Int, Never>()
    
    private var annouceViewModel = AnnouceListViewModel()
    private var type: AnnouceListType
    weak var coordinator: HomeCoordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var topDataSource: UICollectionViewDiffableDataSource<AnnouceSectionType, AssociationModel>!
    private var bottomDataSource: UICollectionViewDiffableDataSource<AnnouceSectionType, BottomSectionItem>!
    
    // MARK: - UI Properties
    
    private var topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - init
    
    init(type: AnnouceListType, coordinator: HomeCoordinator) {
        self.type = type
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
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupCollectionView()
        configureDataSource()
        bindViewModel()
        
        annouceViewModel.getMyAssociation()
        
        // type에 따른 데이터 요청
        switch type {
        case .association:
            annouceViewModel.getAnnouceData()
        case .bookmark:
            annouceViewModel.getBookmarkData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let customNavController = self.navigationController as? CustomAnnouceNavigationController {
            customNavController.setNavigationType(.announce)
        }
        
        
//        self.navigationController?.isNavigationBarHidden = true
    }
}

private extension AnnouceListViewController {
    /// 상단 CollectionView Snapshot
    func updateAssociationSnapshot(with associations: [AssociationModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<AnnouceSectionType, AssociationModel>()
        snapshot.appendSections([.association])
        snapshot.appendItems(associations)
        topDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    /// 하단 CollectionView Snapshot
    func updateBottomSnapshot(with items: [BottomSectionItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<AnnouceSectionType, BottomSectionItem>()
        snapshot.appendSections([.annouceList])
        snapshot.appendItems(items)
        bottomDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureDataSource() {
        // 상단 CollectionView DataSource
        topDataSource = UICollectionViewDiffableDataSource<AnnouceSectionType, AssociationModel>(collectionView: topCollectionView) { collectionView, indexPath, association in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssociationCollectionViewCell.className, for: indexPath) as? AssociationCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(forModel: association)
            return cell
        }
        
        // 하단 CollectionView DataSource
        bottomDataSource = UICollectionViewDiffableDataSource(collectionView: bottomCollectionView) { [weak self] collectionView, indexPath, item in
            switch self?.type {
            case .association:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnnouceListCollectionViewCell.className, for: indexPath) as? AnnouceListCollectionViewCell,
                      case .association(let model) = item else {
                    return UICollectionViewCell()
                }
                
                cell.configureCell(forModel: model)
                return cell
                
            case .bookmark:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkListCollectionViewCell.className,for: indexPath) as? BookmarkListCollectionViewCell,
                      case .bookmark(let model) = item else {
                    return UICollectionViewCell()
                }
                
                cell.configureCell(forModel: model)
                return cell
                
            default:
                return UICollectionViewCell()
            }
        }
    }
}

private extension AnnouceListViewController {
    private func bindViewModel() {
        
        let input = AnnouceListViewModel.Input()
        let output = annouceViewModel.transform(input: input)
        
        // Snapshot 업데이트를 위한 바인딩
        output.associations
            .sink { [weak self] associations in
                self?.updateAssociationSnapshot(with: associations)
            }
            .store(in: &cancellables)
            
        // type에 따라 다른 데이터 바인딩
        switch type {
        case .association:
            output.announces
                .sink { [weak self] announces in
                    let items = announces.map { BottomSectionItem.association($0) }
                    self?.updateBottomSnapshot(with: items)
                }
                .store(in: &cancellables)
            
        case .bookmark:
            output.bookmarks
                .sink { [weak self] bookmarks in
                    let items = bookmarks.map { BottomSectionItem.bookmark($0) }
                    self?.updateBottomSnapshot(with: items)
                }
                .store(in: &cancellables)
        }
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
    
    func setupHierarchy() {
        view.addSubviews(topCollectionView, bottomCollectionView)
    }
    
    func setupLayout() {
        topCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(113)
        }
        
        bottomCollectionView.snp.makeConstraints {
            $0.top.equalTo(topCollectionView.snp.bottom).offset(11)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
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
            bottomCollectionView.register(AnnouceListCollectionViewCell.self, forCellWithReuseIdentifier: AnnouceListCollectionViewCell.className)
        case .bookmark:
            bottomCollectionView.register(BookmarkListCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkListCollectionViewCell.className)
        }
    }
}

extension AnnouceListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case topCollectionView:
            return CGSize(width: 75, height: 99)
            
        case bottomCollectionView:
            switch type {
            case .association:
                return CGSize(width: collectionView.bounds.width, height: 154)
            case .bookmark:
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

extension AnnouceListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case topCollectionView:
            let data = annouceViewModel.announcesSubject.value[indexPath.row]
            
            
        case bottomCollectionView:
            switch type {
            case .association:
                let data = annouceViewModel.announcesSubject.value[indexPath.row]
//                selectedAnnouceSubject.send(indexPath.row)
                
                coordinator?.pushDetailAnnouce()
                
                
            case .bookmark:
                let data = annouceViewModel.bookmarkSubject.value[indexPath.row]
//                selectedAnnouceSubject.send(indexPath.row)
                
                coordinator?.pushDetailAnnouce()
            }

        default:
            break
        }
    }
}
