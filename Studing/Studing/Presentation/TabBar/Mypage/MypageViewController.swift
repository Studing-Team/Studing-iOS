//
//  MypageViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class MypageViewController: UIViewController {
    
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private let mypageViewModel: MypageViewModel
    
    weak var coordinator: MypageCoordinator?
    
    // MARK: - UI Properties
    
    private let studingHeaderView = StudingHeaderView(type: .mypage)
    
    private lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    }()
    
    // MARK: - init
    
    init(mypageViewModel: MypageViewModel,
        coordinator: MypageCoordinator) {
        self.mypageViewModel = mypageViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupCollectionView()
        bindViewModel()
        
        viewDidLoadSubject.send(())
    }
}

// MARK: - Private Bind Extensions

private extension MypageViewController {
    func bindViewModel() {
        let input = MypageViewModel.Input(
            viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher()
        )
        
        let output = mypageViewModel.transform(input: input)
        
        output.myPageInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] info in
                
                if info != nil {
                    self?.collectionView.reloadSections(IndexSet(integer: 0))
                }
//                self?.collectionView.reloadSections(IndexSet(integer: MyPageType.myInfo))
            }
            .store(in: &cancellables)
    }
}


// MARK: - Private Extensions

private extension MypageViewController {
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupStyle() {
        view.applyGradient(colors: [.loginStartGradient.withFigmaStyleAlpha(0.3), .loginEndGradient.withFigmaStyleAlpha(0.3)], direction: .topToBottom, locations: [0, 0.5])
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
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}


// MARK: - CollectionView Extension

private extension MypageViewController {
    func setupCollectionView() {

        collectionView.backgroundColor = .clear
        
        // Cell 등록
        collectionView.register(MyInfoCollectionViewCell.self, forCellWithReuseIdentifier: MyInfoCollectionViewCell.className)
        
        collectionView.register(MyPageAnotherCollectionViewCell.self, forCellWithReuseIdentifier: MyPageAnotherCollectionViewCell.className)
        
        // 커스텀 헤더 뷰 등록
        collectionView.register(MypageHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MypageHeaderCollectionReusableView.className)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            
            let sectionType = MyPageType.allCases[sectionIndex]
            
            switch sectionType {
            case .myInfo:
                return self.createMyInfoSection()
            case .useInfo, .etc:
                return self.createAnthoerSection()
            }
        }
        
        // 배경 뷰 등록
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: "background")
        
        return layout
    }
    
    func createMyInfoSection() -> NSCollectionLayoutSection {
        // Item 정의
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group 정의
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(194)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section 정의
        let section = NSCollectionLayoutSection(group: group)
        
        // 섹션에 패딩 추가
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 19, bottom: 21, trailing: 20)

        // 스크롤 비활성화 (단일 셀이므로)
        section.orthogonalScrollingBehavior = .none

        return section
    }
    
    func createAnthoerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(53)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading:15, bottom: 0, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20)
        
        // 배경 추가
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: "background")
        backgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
        section.decorationItems = [backgroundDecoration]
        
        // 헤더 추가
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}

extension MypageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MyPageType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MyPageType.allCases[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MypageHeaderCollectionReusableView.className, for: indexPath) as! MypageHeaderCollectionReusableView
        
        let sectionType = MyPageType.allCases[indexPath.section]
        headerView.configureHeader(headerTitle: sectionType.title)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = MyPageType.allCases[indexPath.section]
        
        switch section {
        case .myInfo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyInfoCollectionViewCell.className, for: indexPath) as! MyInfoCollectionViewCell
            
            if let myPageInfo = mypageViewModel.myPageInfoSubject.value {
                cell.configureCell(forModel: myPageInfo)
            }
            
            return cell
            
            return cell
            
        case .useInfo, .etc:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageAnotherCollectionViewCell.className, for: indexPath) as! MyPageAnotherCollectionViewCell
            
            // MyInfo 셀 구성
            cell.configureCell(title: section.items[indexPath.row])
            
            // 마지막 셀의 구분선 숨기기
            if indexPath.row == section.items.count - 1 {
                cell.hideSeparator()
            } else {
                cell.showSeparator()
            }
            
            return cell
        }
    }
}
