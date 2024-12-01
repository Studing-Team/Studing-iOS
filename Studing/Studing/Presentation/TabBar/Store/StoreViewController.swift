//
//  StoreViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import Combine
import UIKit

import SnapKit
import Then

import NMapsMap

final class StoreViewController: UIViewController {
    
    // MARK: - Properties
    
    private let storeViewModel: StoreViewModel
    weak var coordinator: StoreCoordinator?
    
    private var storeDataSource: UICollectionViewDiffableDataSource<Int, StoreEntity>!
    
    // MARK: - Combine Publishers Properties
    
    private let categorySelectionSubject = PassthroughSubject<CategoryType, Never>()
    private let searchTextSubject = PassthroughSubject<String, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let customSearchBarView = CustomSearchBarView()
    private let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var storeCollectionView = UICollectionView(frame: .zero,collectionViewLayout: createStoreLayout())
    
    // MARK: - init
    
    init(storeViewModel: StoreViewModel,
         coordinator: StoreCoordinator) {
        self.storeViewModel = storeViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.applyGradient(colors: [.loginStartGradient.withFigmaStyleAlpha(0.3), .loginEndGradient.withFigmaStyleAlpha(0.3)], direction: .topToBottom, locations: [0, 1.0])
        
        hideKeyboard()
        setNavigationBar()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupCollectionView()
        
        configureStoreDataSource()
        bindViewModel()

//        let indexPath = IndexPath(item: 0, section: 0)
//        categoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        
        categorySelectionSubject.send(.all)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
}

// MARK: - Private Extensions

private extension StoreViewController {
    func bindViewModel() {
        let input = StoreViewModel.Input(
            categoryTap: categorySelectionSubject.eraseToAnyPublisher(),
            searchStoreName: searchTextSubject.eraseToAnyPublisher()
        )
        
        let output = storeViewModel.transform(input: input)
        
        output.storeList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stores in
                self?.applyStoreSnapshot(with: stores)
                self?.storeCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            .store(in: &cancellables)
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupStyle() {
        customSearchBarView.do {
            $0.layer.cornerRadius = 24
            $0.clipsToBounds = true
            
            $0.layer.shadowColor = UIColor.black30.cgColor  // 그림자 색상
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)  // 그림자 위치
            $0.layer.shadowOpacity = 1.0  // 그림자 투명도
            $0.layer.shadowRadius = 6  // 그림자 퍼짐 정도
        }
        
        categoryCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal  // 가로 스크롤 설정
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            
            $0.layer.shadowColor = UIColor.storeShadowBackground.withFigmaStyleAlpha(0.3).cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 7)
            $0.collectionViewLayout = layout
            $0.backgroundColor = .clear
            $0.allowsMultipleSelection = false
            $0.scrollsToTop = true
            $0.showsHorizontalScrollIndicator = false
        }
        
        storeCollectionView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(customSearchBarView, categoryCollectionView, storeCollectionView)
    }
    
    func setupLayout() {
        customSearchBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(29)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(customSearchBarView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        storeCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setupDelegate() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        customSearchBarView.delegate = self
    }
}

// MARK: - Private CollectionView Extensions

private extension StoreViewController {
    func setupCollectionView() {
        categoryCollectionView.register(StoreCategoryCollectionViewCell.self, forCellWithReuseIdentifier: StoreCategoryCollectionViewCell.className)
        storeCollectionView.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: StoreCollectionViewCell.className)
    }
    
    func createStoreLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(380) // 154  338 360
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(380) // 154
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
        section.interGroupSpacing = 8
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func applyStoreSnapshot(with stores: [StoreEntity]) {
        if stores.isEmpty {
            let emptyView = EmptyStateView()
            storeCollectionView.backgroundView = emptyView
        } else {
            storeCollectionView.backgroundView = nil
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, StoreEntity>()
        snapshot.appendSections([0])
        snapshot.appendItems(stores)
        
        storeDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureStoreDataSource() {
        storeDataSource = UICollectionViewDiffableDataSource(collectionView: storeCollectionView) { collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCollectionViewCell.className, for: indexPath ) as? StoreCollectionViewCell else { return UICollectionViewCell() }
                        
            cell.configureCell(forModel: item)
            cell.delegate = self
            cell.expandedBenefitView.mapDelegate = self
            
//            cell.expandedBenefitView.configureData(forModel: BenefitModel(title: [item.partnerContent]), storeName: item.name)
            return cell
        }
    }
}

// MARK: - UICollection Delegate Extensions

extension StoreViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard collectionView == categoryCollectionView else { return .zero }
        
        let category = CategoryType.allCases[indexPath.item]
        
        // 아이콘 너비 + 간격 + 텍스트 너비 + 좌우 여백
        let iconWidth: CGFloat = 24 // 아이콘 크기
        let spacing: CGFloat = 5    // 스택뷰 spacing
        let horizontalPadding: CGFloat = 20 // 좌우 여백 (10 + 10)
        
        // 텍스트 크기 계산
        let label = UILabel()
        label.font = .interBody2()
        label.text = category.title
        let titleWidth = label.intrinsicContentSize.width
        
        let cellWidth = iconWidth + spacing + titleWidth + horizontalPadding
        return CGSize(width: cellWidth, height: 38) // height는 verticalEdges.inset(7) * 2 + 아이콘 높이
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacing section: Int) -> CGFloat {
        switch collectionView {
        case categoryCollectionView:
            return 5
        case storeCollectionView:
            return 8
        default:
            return 0
        }
    }
}

extension StoreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let category = CategoryType.allCases[indexPath.row]
            categorySelectionSubject.send(category)
            
        } else if collectionView == storeCollectionView {
            var snapshot = storeDataSource.snapshot()
            var items = snapshot.itemIdentifiers

            // 선택된 셀만 토글
            items[indexPath.item].isExpanded.toggle()
            
            snapshot = NSDiffableDataSourceSnapshot<Int, StoreEntity>()
            snapshot.appendSections([0])
            snapshot.appendItems(items)
            
            self.storeDataSource.apply(snapshot, animatingDifferences: true)

            self.storeCollectionView.scrollToItem(
                at: indexPath,
                at: .centeredVertically,
                animated: true
            )
        }
    }
}

extension StoreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCategoryCollectionViewCell.className, for: indexPath) as? StoreCategoryCollectionViewCell else { return UICollectionViewCell() }
        
        let category = CategoryType.allCases[indexPath.row]
        cell.configureCell(type: category)
        
        // 첫 번째 셀이면서 아직 선택된 셀이 없는 경우
        if indexPath.item == 0 && collectionView.indexPathsForSelectedItems?.isEmpty ?? true {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            categorySelectionSubject.send(category)
        }
        
        return cell
    }
}

// ViewController에서 delegate 구현
extension StoreViewController: StoreCellDelegate {
    
    func expandedCellTap(_ cell: StoreCollectionViewCell) {
        guard let indexPath = storeCollectionView.indexPath(for: cell) else { return }
        
        var snapshot = storeDataSource.snapshot()
        var items = snapshot.itemIdentifiers

        // 선택된 셀만 토글
        items[indexPath.item].isExpanded.toggle()
    
        snapshot = NSDiffableDataSourceSnapshot<Int, StoreEntity>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        
        self.storeDataSource.apply(snapshot, animatingDifferences: true)

        self.storeCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredVertically,
            animated: true
        )
    }
}

extension StoreViewController: CustomSearchBarViewDelegate {
    func searchBar(_ searchBar: CustomSearchBarView, textDidChange text: String) {
        searchTextSubject.send(text)
    }
}

extension StoreViewController: ShowStoreMapDelegate {
    func showStoreMap(storeName: String) {
        
        if let index = storeViewModel.storeDataSubject.value.firstIndex(where: { $0.name == storeName }) {
            print("선택된 인덱스:", index)
            
            self.coordinator?.pushStoreMap(storeData: storeViewModel.storeDataSubject.value[index])
        }
    }
}
