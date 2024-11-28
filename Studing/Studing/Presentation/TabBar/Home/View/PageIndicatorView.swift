//
//  PageIndicatorView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/21/24.
//

import UIKit

import SnapKit
import Then

enum PageFooterType {
    case home
    case list
}

final class PageFooterView: UICollectionReusableView {
    
    private let bannerPageControl = UIPageControl()
    private var type: PageFooterType?
    
    var currentPage: Int = 0 {
        didSet {
            bannerPageControl.currentPage = currentPage
        }
    }
    
    var numberOfPages: Int {
        get {
            return bannerPageControl.numberOfPages
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(pageNumber: Int, type: PageFooterType) {
        bannerPageControl.numberOfPages = pageNumber
        self.type = type
        
        setupStyle()
    }
    
    func setupStyle() {
        bannerPageControl.do {
            $0.pageIndicatorTintColor = type == .home ? .white : .black10
            $0.currentPageIndicatorTintColor = .primary50
            $0.currentPage = 0
            $0.isUserInteractionEnabled = false
        }
    }
    
    func setupHierarchy() {
        addSubview(bannerPageControl)
    }
    
    func setupLayout() {
        bannerPageControl.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}
