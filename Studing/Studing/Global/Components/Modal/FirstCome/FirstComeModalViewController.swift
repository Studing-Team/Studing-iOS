//
//  FirstComeModalViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/24/25.
//

import Combine
import UIKit

import SnapKit
import Then

final class FirstComeModalViewController: DoubleButtonSheetViewController {
    
    // MARK: - Combine Properties
    
    private let viewLifeCycleSubject = PassthroughSubject<ViewLifeCycleEvent, NetworkError>()
    private let findMyRankingSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private var firstComeModalViewModel: FirstComeModalViewModel
    
    // MARK: - UI Properties
    
    private let indexSectionView = IndexSectionView()
    private let timeListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Init
    
    init(
        firstComeModalViewModel: FirstComeModalViewModel
    ) {
        self.firstComeModalViewModel = firstComeModalViewModel

        super.init(
            leftButtonStyle: .close(type: .gray),
            rightButtonStyle: .myRanking
        )
        
        self.bindingBottomLeftButtonAction(action: { [weak self] in
            self?.dismiss(animated: true)
        })
        
        self.bindingBottomRightButtonAction(action: { [weak self] in
            self?.findMyRankingSubject.send()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("FirstComeModalViewController deinit")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Push FirstComeModalViewController")
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        bindViewModel()
        
        viewLifeCycleSubject.send(.viewDidLoad)
    }
}

// MARK: - Private Bind Extensions

private extension FirstComeModalViewController {
    func bindViewModel() {
        let input = FirstComeModalViewModel.Input(
            viewLifeCycleEventAction: viewLifeCycleSubject.eraseToAnyPublisher(),
            findMyRankAction: findMyRankingSubject.eraseToAnyPublisher()
        )
        
        let output = firstComeModalViewModel.transform(input: input)
        
        output.firstComeRankingsResult
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] result in
                if result {
                    self?.timeListCollectionView.reloadData()
                }
            })
            .store(in: &cancellables)
        
        output.findMyRankResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self, let index = result else {
                    // TODO: - 해당 내용을 찾을 수 없다는 로직
                    return
                }
                
                let indexPath = IndexPath(item: index - 1, section: 0)
                
                if let cell = self.timeListCollectionView.cellForItem(at: indexPath) as? TimeListCollectionViewCell {
                    cell.selectMyRankToCell(true)
                }
                
                // 셀 업데이트
//                self.timeListCollectionView.reloadItems(at: [indexPath])
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Extensions

private extension FirstComeModalViewController {
    func setupStyle() {
        timeListCollectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.register(TimeListCollectionViewCell.self, forCellWithReuseIdentifier: TimeListCollectionViewCell.className)
        }
    }
    
    func setupHierarchy() {
        self.contentAreaView.addSubviews(indexSectionView, timeListCollectionView)
    }
    
    func setupLayout() {
        indexSectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.horizontalEdges.equalToSuperview()
        }
        
        timeListCollectionView.snp.makeConstraints {
            $0.top.equalTo(indexSectionView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(view.convertByHeightRatio(424))
        }
    }
    
    func setupDelegate() {
        self.timeListCollectionView.delegate = self
        self.timeListCollectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Extensions

extension FirstComeModalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 42) // 적절한 높이 설정
    }
    
    // ContentInset: Cell에서 Content 외부에 존재하는 Inset의 크기를 결정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // minimumLineSpacing: Cell 들의 위, 아래 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

extension FirstComeModalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return firstComeModalViewModel.firstComeRankingData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeListCollectionViewCell.className, for: indexPath) as? TimeListCollectionViewCell else { return UICollectionViewCell() }

        guard let data = firstComeModalViewModel.firstComeRankingData else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(for: data[indexPath.row])
        
        return cell
    }
}
