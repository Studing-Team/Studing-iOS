//
//  NoExistsSearchResultView.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/3/24.
//

import UIKit

import SnapKit
import Then

enum SerachResultType {
    case university
    case major
    
    var title: String {
        switch self {
        case .university:
            return StringLiterals.Title.noExistsSerachUniversity
        case .major:
            return StringLiterals.Title.noExistsSerachMajor
        }
    }
    
    var subTitle: String {
        switch self {
        case .university:
            return StringLiterals.SubTitle.noExistsSerachUniversity
        case .major:
            return StringLiterals.SubTitle.noExistsSerachMajor
        }
    }
}

final class NoExistsSearchResultView: UIView {
    
    // MARK: - Properties
    
    private let serachResultType: SerachResultType
    
    // MARK: - UI Properties
    
    private let searchResultTitleLabel = UILabel()
    private let searchResultSubTitleLabel = UILabel()
    private let addInfoButton: CustomButton
    
    // MARK: - Life Cycle
    
    init(serachResultType: SerachResultType) {
        self.serachResultType = serachResultType
        self.addInfoButton = CustomButton(buttonStyle: serachResultType == .university ? .registerUniverstiy : .registerMajor)
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension NoExistsSearchResultView {
    func setupStyle() {
        searchResultTitleLabel.do {
            $0.text = serachResultType.title
            $0.font = .interSubtitle1()
            $0.textColor = .black50
        }
        
        searchResultSubTitleLabel.do {
            $0.text = serachResultType.subTitle
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.font = .interBody3()
            $0.textColor = .black40
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(searchResultTitleLabel, searchResultSubTitleLabel, addInfoButton)
    }
    
    func setupLayout() {
        searchResultTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        searchResultSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(searchResultTitleLabel.snp.bottom).offset(convertByHeightRatio(20))
            $0.centerX.equalToSuperview()
        }
        
        addInfoButton.snp.makeConstraints {
            $0.top.equalTo(searchResultSubTitleLabel.snp.bottom).offset(convertByHeightRatio(135))
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
    
    func setupDelegate() {
        
    }
}
