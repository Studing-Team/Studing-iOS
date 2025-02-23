//
//  FirstComeContentView.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/21/25.
//

import UIKit

import SnapKit
import Then

final class FirstComeContentView: UIView, SheetContentConfigurable {
    
    // MARK: - Properties
    
    private let viewModel: FirstComeModalViewModel
    
    // MARK: - SheetContentConfigurable Properties
    
    var contentView: UIView { return self }
    
    // MARK: - UI Properties
    
    private let indexSectionView = IndexSectionView()
    private let timeListCollectionView: UICollectionView
    
    // MARK: - Init
    
    init(viewModel: FirstComeModalViewModel) {
        self.viewModel = viewModel
        self.timeListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(frame: .zero)
        
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent() {
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    func updateCollectionView() {
        timeListCollectionView.reloadData()
    }
    
    func selectRank(at index: Int) {
        let indexPath = IndexPath(item: index - 1, section: 0)
        if let cell = timeListCollectionView.cellForItem(at: indexPath) as? TimeListCollectionViewCell {
            cell.selectMyRankToCell(true)
        }
    }
}

// MARK: - Private Extensions

private extension FirstComeContentView {
    func setupStyle() {
        timeListCollectionView.do {
            $0.showsVerticalScrollIndicator = false
            $0.register(TimeListCollectionViewCell.self, forCellWithReuseIdentifier: TimeListCollectionViewCell.className)
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    func setupHierarchy() {
        contentView.addSubviews(indexSectionView, timeListCollectionView)
    }
    
    func setupLayout() {
        indexSectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.horizontalEdges.equalToSuperview()
        }
        
        timeListCollectionView.snp.makeConstraints {
            $0.top.equalTo(indexSectionView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(445)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Extensions

extension FirstComeContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UICollectionViewDataSource Extensions

extension FirstComeContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.firstComeRankingData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeListCollectionViewCell.className, for: indexPath) as? TimeListCollectionViewCell else { return UICollectionViewCell() }
        
        guard let data = viewModel.firstComeRankingData else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(for: data[indexPath.row])
        return cell
    }
}
