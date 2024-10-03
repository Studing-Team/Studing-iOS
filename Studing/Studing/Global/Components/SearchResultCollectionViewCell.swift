//
//  SearchResultCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/3/24.
//

import UIKit

import SnapKit
import Then

final class SearchResultCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let dotImageView = UIImageView()
    private let searchResultLabel = UILabel()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension SearchResultCollectionViewCell {
    func configureCell(forModel model : any SearchResultModel, searchName: String) {
   
        let attributedString = NSMutableAttributedString(string: model.resultData)
        
        // 기본 폰트와 색상 설정
        attributedString.addAttributes([
            .font: UIFont.interBody1(),
            .foregroundColor: UIColor.black50
        ], range: NSRange(location: 0, length: model.resultData.count))
        
        // 검색어에 해당하는 부분 찾기
        if let range = model.resultData.range(of: searchName, options: .caseInsensitive) {
            let nsRange = NSRange(range, in: model.resultData)
            
            // 검색어에 해당하는 부분의 폰트와 색상 변경
            attributedString.addAttributes([
                .font: UIFont.interSubtitle2(),
                .foregroundColor: UIColor.primary50
            ], range: nsRange)
        }
        
        searchResultLabel.attributedText = attributedString
    }
}

// MARK: - Private Extensions

private extension SearchResultCollectionViewCell {
    func setupStyle() {
        dotImageView.do {
            $0.image = UIImage(systemName: "circle.fill")
            $0.tintColor = .black50
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFit
        }
        
        searchResultLabel.do {
            $0.font = .interBody1()
            $0.textColor = .black50
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(dotImageView, searchResultLabel)
    }
    
    func setupLayout() {
        dotImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(4)
        }
        
        searchResultLabel.snp.makeConstraints {
            $0.leading.equalTo(dotImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
    }
}
