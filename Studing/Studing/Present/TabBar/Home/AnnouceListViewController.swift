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
    
    private var selectedAssociationSubject = PassthroughSubject<Int, Never>()
    private var annouceViewModel = AnnouceListViewModel()
    private var type: AnnouceListType
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var topDataSource: UICollectionViewDiffableDataSource<AnnouceSectionType, AssociationModel>!
    private var bottomDataSource: UICollectionViewDiffableDataSource<AnnouceSectionType, BottomSectionItem>!
    
    // MARK: - UI Properties
    
    private var topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - init
    
    init(type: AnnouceListType) {
        self.type = type
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
        self.navigationController?.isNavigationBarHidden = false
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
    
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
            $0.showsHorizontalScrollIndicator = false
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
            $0.horizontalEdges.equalToSuperview()
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
                return CGSize(width: 335, height: 154)
            case .bookmark:
                return CGSize(width: 335, height: 100)
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

//extension AnnouceListViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch collectionView {
//        case topCollectionView:
//            return 1
//        case bottomCollectionView:
//            return 1
//        default:
//            return 0
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        switch collectionView {
//        case topCollectionView:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssociationCollectionViewCell.className, for: indexPath) as? AssociationCollectionViewCell else { return UICollectionViewCell() }
//            
//            
//            
//            return cell
//        case bottomCollectionView:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnnouceListCollectionViewCell.className, for: indexPath) as? AnnouceListCollectionViewCell else { return UICollectionViewCell() }
//            
//            
//            
//            c
//            return cell
//        default:
//            return UICollectionViewCell()
//        }
//    }
//}

//final class AnnouceListViewController: UIViewController {
//    
//    // MARK: - Properties
//    
//    private var selectedAssociationSubject = PassthroughSubject<Int, Never>()
//    private var annouceViewModel = AnnouceListViewModel()
//    private var type: AnnouceListType
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    // MARK: - UI Properties
//    
//    private var collectionView: UICollectionView!
//    private var topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//    private var bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//    private var dataSource: UICollectionViewDiffableDataSource<AnnouceSectionType, AnyHashable>!
//    
//    // MARK: - init
//    
//    init(type: AnnouceListType) {
//        self.type = type
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Life Cycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.applyGradient(colors: [.loginStartGradient.withFigmaStyleAlpha(0.3), .loginEndGradient.withFigmaStyleAlpha(0.3)], direction: .topToBottom, locations: [0, 0.5])
//        
//        setupCollectionView()
//        configureDataSource()
//        applySnapshot()
//        
////        setNavigationBar()
//        setupStyle()
//        setupHierarchy()
//        setupLayout()
//        setupDelegate()
//        bindViewModel()
//        
//        annouceViewModel.getMyAssociation()
//        annouceViewModel.getAnnouceData()
//        annouceViewModel.getMySections()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = false
//    }
//}
//
//// MARK: - Private Extensions
//
//private extension AnnouceListViewController {
//    func setNavigationBar() {
////        navigationItem.title = "홈"
//        self.navigationController?.isNavigationBarHidden = false
//        let appearance = UINavigationBarAppearance()
//                
//        // 기본 스타일 설정
//        appearance.configureWithOpaqueBackground()  // 불투명 배경
//        
//        // 배경 설정
//        appearance.backgroundColor = .clear
//        appearance.shadowColor = .clear
//        // 타이틀 텍스트 스타일
//        appearance.titleTextAttributes = [
//            .foregroundColor: UIColor.black,
//            .font: UIFont.boldSystemFont(ofSize: 18)
//        ]
//        
//        // 버튼 스타일
//        appearance.buttonAppearance.normal.titleTextAttributes = [
//            .foregroundColor: UIColor.black
//        ]
//        
//        // 적용
//        navigationController?.navigationBar.standardAppearance = appearance     // 기본 상태
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance  
//        
//        setupNavigationBar()// 스크롤시
//    }
//    
//    private func setupNavigationBar() {
////        let customButton = UIButton(type: .system)
////        
////        // 이미지와 타이틀 설정
////        customButton.setTitle("학생회 공지 리스트", for: .normal)
////        customButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
////        
////        // 이미지와 타이틀 색상 설정
////        customButton.tintColor = .black  // 이미지 색상
////        customButton.setTitleColor(.black, for: .normal)  // 텍스트 색상
////        
////        // 폰트 설정
////        customButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)  // 원하는 폰트로 변경
////        
////        // 이미지 위치 설정 (이미지를 왼쪽에)
////        customButton.semanticContentAttribute = .forceLeftToRight
////        
////        // 이미지와 타이틀 사이 간격 설정
////        customButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
////        customButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
////        
////        // 전체 버튼의 여백 설정
////        customButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
////        
////        customButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
////        
////        let leftBarButton = UIBarButtonItem(customView: customButton)
////        navigationItem.leftBarButtonItem = leftBarButton
////        // 기존 appearance 설정...
////        
////        // 커스텀 버튼 생성
////        let customButton = UIButton(type: .system)
////        customButton.setTitle("학생회 공지 리스트", for: .normal)
////        customButton.setTitleColor(.black, for: .normal)
////        customButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
////        
////        customButton.titleLabel?.font = .systemFont(ofSize: 16)
////        
////        customButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
////        
////        // 버튼을 UIBarButtonItem으로 변환
////        let leftBarButton = UIBarButtonItem(customView: customButton)
////        
////        // 추가 여백을 주기 위한 스페이스 아이템
////        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
////        spacer.width = 10  // 원하는 여백
////        
////        // 네비게이션 아이템에 설정
////        navigationItem.leftBarButtonItems = [spacer, leftBarButton]
//    }
//
//    @objc private func backButtonTapped() {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    func setupStyle() {
//        collectionView.do {
//            $0.allowsMultipleSelection = false
//            $0.isScrollEnabled = true
//        }
//        
//        topCollectionView.do {
//            $0.backgroundColor = .clear
//            $0.showsHorizontalScrollIndicator = false
//        }
//        
//        bottomCollectionView.do {
//            $0.backgroundColor = .clear
//            $0.showsHorizontalScrollIndicator = false
//        }
//    }
//    
//    func setupHierarchy() {
//        view.addSubviews(collectionView)
////        view.addSubviews(topCollectionView, bottomCollectionView)
//    }
//    
//    func setupLayout() {
//        collectionView.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            $0.horizontalEdges.equalToSuperview()
//            $0.bottom.equalToSuperview()
//        }
////        topCollectionView.snp.makeConstraints {
////            $0.top.equalToSuperview()
////            $0.horizontalEdges.equalToSuperview()
////        }
////        
////        bottomCollectionView.snp.makeConstraints {
////            $0.top.equalTo(topCollectionView.snp.bottom).offset(87)
////            $0.horizontalEdges.equalToSuperview()
////            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
////        }
//    }
//    
//    func setupDelegate() {
//        collectionView.delegate = self
////        topCollectionView.delegate = self
////        bottomCollectionView.delegate = self
//    }
//}
//
//private extension AnnouceListViewController {
//    func setupCollectionView() {
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
//        collectionView.backgroundColor = .clear
//
//        collectionView.register(AssociationCollectionViewCell.self, forCellWithReuseIdentifier: AssociationCollectionViewCell.className)
//        collectionView.register(AnnouceListCollectionViewCell.self, forCellWithReuseIdentifier: AnnouceListCollectionViewCell.className)
//        
//        topCollectionView.register(AssociationCollectionViewCell.self, forCellWithReuseIdentifier: AssociationCollectionViewCell.className)
//        bottomCollectionView.register(AnnouceListCollectionViewCell.self, forCellWithReuseIdentifier: AnnouceListCollectionViewCell.className)
//    }
//    
//    func createLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            guard let self else { return nil }
//            
//            guard let sectionTypes = self.annouceViewModel.sectionsData.value, sectionIndex < sectionTypes.count else { return nil }
//            
//            let sectionType = sectionTypes[sectionIndex]
//            
//            var section: NSCollectionLayoutSection
//            
//            switch sectionType {
//            case .association:
//                section = self.createAssociationSection()
//                
//                section.visibleItemsInvalidationHandler = { _, contentOffset, environment in
//                    let y = contentOffset.y
//                }
//                
//            case .annouceList:
//                section = self.createAnnouceSection()
//            }
// 
//            return section
//        }
//        
//        return layout
//    }
//    
//    func createAssociationSection() -> NSCollectionLayoutSection {
//        // Item 정의
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(75),
//            heightDimension: .absolute(99)
//        )
//        
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//       
//        // Group 정의
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(75),
//            heightDimension: .absolute(99)       // 높이만 고정
//        )
//        
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//        // Section 정의
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 10
//        // 섹션에 패딩 추가
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 29, trailing: 20)
//        
//        section.orthogonalScrollingBehavior = .continuous
////        section.pinToVisibleBounds = true
//        
//        return section
//    }
//    
//    func createAnnouceSection() -> NSCollectionLayoutSection {
//        // Item 정의
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .absolute(152)
//        )
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
//
//        // Group 정의
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),  // 섹션 너비의 100%
////            heightDimension: .fractionalHeight(1.0)       // 높이만 고정
//            heightDimension: .estimated(1.0)       // 높이만 고정
//        )
//        
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//        
//        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//        
//        // Section 정의
//        let section = NSCollectionLayoutSection(group: group)
//        
//        // 섹션에 패딩 추가
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0)
//        
////        section.orthogonalScrollingBehavior = .continuous
////        section.interGroupSpacing = 12  // 셀 간격 추가
//
//        return section
//    }
//    
//    
//    func configureDataSource() {
//       dataSource = UICollectionViewDiffableDataSource<AnnouceSectionType, AnyHashable>(collectionView: collectionView) {
//           (collectionView, indexPath, item) -> UICollectionViewCell? in
//           
//           guard let sectionType = self.annouceViewModel.sectionsData.value?[indexPath.section] else { return nil }
//           
//           switch sectionType {
//           case .association:
//               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssociationCollectionViewCell.className, for: indexPath) as! AssociationCollectionViewCell
//               if let model = item as? AssociationModel {
//                   cell.configureCell(forModel: model)
//               }
//               return cell
//               
//           case .annouceList:
//               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnnouceListCollectionViewCell.className, for: indexPath) as! AnnouceListCollectionViewCell
//               if let model = item as? AssociationAnnounceListModel {
//                   cell.configureCell(forModel: model)
//               }
//               return cell
//           }
//       }
//       
////   dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
////       guard kind == UICollectionView.elementKindSectionHeader else { return nil }
////
////           // sectionsData의 현재 값에 접근하고, 값이 nil이 아닌지 확인
////           guard let sections = self?.annouceViewModel.sectionsData.value,
////                 indexPath.section < sections.count else {
////               return nil
////           }
////           
////           // 섹션 타입 가져오기
////           let sectionType = sections[indexPath.section]
////
////           // 헤더를 dequeue할 때 타입 명시
////           let header = collectionView.dequeueReusableSupplementaryView(
////               ofKind: kind,
////               withReuseIdentifier: CustomHeaderCollectionReusableView.className,
////               for: indexPath
////           ) as? CustomHeaderCollectionReusableView
////           
////           // 헤더가 성공적으로 dequeue되었는지 확인
////           guard let header = header else { return nil }
////           
////           // 각 섹션별로 헤더 내용 설정
////           switch sectionType {
////           case .association:
////               header.configureHeader(type: .association, headerTitle: "서울과학기술대학교")
////               
////           case .annouce:
////               header.configureHeader(type: .annouce, headerTitle: self?.homeViewModel.selectedAssociationTitle.value ?? "")
////               header.rightButtonTapped = {
////                   self?.selectedHeaderButtonSubject.send(.annouce)
////               }
////               
////           case .bookmark:
////               header.configureHeader(type: .bookmark, headerTitle: "상우")
////               
////               header.rightButtonTapped = {
////                   self?.selectedHeaderButtonSubject.send(.bookmark)
////               }
////               
////           case .emptyBookmark:
////               header.configureHeader(type: .emptyBookmark, headerTitle: "")
////               
////           default:
////               break
////           }
////
////           return header
////       }
//   }
//    
//    private func applySnapshot() {
//        var snapshot = NSDiffableDataSourceSnapshot<AnnouceSectionType, AnyHashable>()
//        
//        guard let sections = annouceViewModel.sectionsData.value else { return }
//        
//        for section in sections {
//            snapshot.appendSections([section])
//            
//            // 각 섹션 타입에 따라 적절한 모델 객체를 생성하고 추가
//            switch section {
//            case .association:
//                
//                guard let items = annouceViewModel.sectionDataDict[section] else { return }
//                let associationItems = items.compactMap { $0 as? AssociationModel }
//                
//                snapshot.appendItems(associationItems, toSection: section)
//                
//            case .annouceList:
//                
//                guard let items = annouceViewModel.sectionDataDict[section] else { return }
//
//                let annouceItems = items.compactMap { $0 as? AssociationAnnounceListModel }
//                
//                snapshot.appendItems(annouceItems, toSection: section)
//            }
//        }
//        
//        dataSource.apply(snapshot, animatingDifferences: false)
//    }
//    
////    private func topApplySnapshot() {
////        var snapshot = NSDiffableDataSourceSnapshot<Int, AssociationModel>()
////        snapshot.appendSections([0])  // 단순히 0을 사용
////        snapshot.appendItems(items)
////        topDataSource.apply(snapshot, animatingDifferences: true)
////    }
////    
////    private func bottomApplySnapshot() {
////        var snapshot = NSDiffableDataSourceSnapshot<Int, AssociationAnnounceListModel>()
////        snapshot.appendSections([0])  // 단순히 0을 사용
////        snapshot.appendItems(items)
////        bottomDataSource.apply(snapshot, animatingDifferences: true)
////    }
//}
//
//extension AnnouceListViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let sectionType = annouceViewModel.sectionsData.value?[indexPath.section],
//                  sectionType == .association else { return }
//
//            selectedAssociationSubject.send(indexPath.row)
//    }
//}
//
//
////extension AnnouceListViewController: UICollectionViewDelegate {
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        if collectionView == topCollectionView {
////            // Association 선택 처리
////        } else {
////            
////        }
////    }
////}
//
//import SwiftUI
//
//struct Preview: UIViewControllerRepresentable {
//    typealias UIViewControllerType = AnnouceListViewController
//    
//    func makeUIViewController(context: Context) -> AnnouceListViewController {
//        return AnnouceListViewController(type: .association)
//    }
//    
//    func updateUIViewController(_ uiViewController: AnnouceListViewController, context: Context) {
//        
//    }
//    
//}
//        
//@available(iOS 13.0.0, *)
//struct UIPreview: PreviewProvider {
//    static var previews: some View {
//        Preview()
//    }
//}
