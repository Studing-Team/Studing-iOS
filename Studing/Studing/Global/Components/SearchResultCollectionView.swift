//
//  SearchResultCollectionView.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/3/24.
//

import UIKit

import SnapKit
import Then

enum SearchType {
    case university
    case major
}

protocol SearchResultModel: Equatable, Hashable {
    var resultData: String { get }
}

protocol SearchResultCellDelegate: AnyObject {
    func didSelectSearchResult(_ result: any SearchResultModel)
}

final class SearchResultCollectionView<T: SearchResultModel>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    private var searchType: SearchType
    private var currentSearchName: String = ""
    private var data: [T] = []
    
    weak var searchResultDelegate: SearchResultCellDelegate?
    
    // MARK: - Init
    
    init(searchType: SearchType) {
        self.searchType = searchType
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        
        setupStyle()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(with data: [T], serachName: String) {
        self.data = data
        self.currentSearchName = serachName
        self.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.className, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        
        let model = data[indexPath.row]
        cell.configureCell(forModel: model, searchName: currentSearchName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = data[indexPath.row]
        searchResultDelegate?.didSelectSearchResult(selectedItem)
    }
    
    // sizeForItemAt: 각 Cell의 크기를 CGSize 형태로 return
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.convertByWidthRatio(335), height: 20)
    }
    
    // ContentInset: Cell에서 Content 외부에 존재하는 Inset의 크기를 결정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 20)
    }
    
    // minimumLineSpacing: Cell 들의 위, 아래 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

// MARK: - Private Extensions

private extension SearchResultCollectionView {
    func setupStyle() {
        self.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.className)
        }
    }
    
    func setupDelegate() {
        self.dataSource = self
        self.delegate = self
    }
}

extension SearchResultCollectionView: SearchResultCellDelegate {
    func didSelectSearchResult(_ result: any SearchResultModel) {
        searchResultDelegate?.didSelectSearchResult(result)
    }
}
