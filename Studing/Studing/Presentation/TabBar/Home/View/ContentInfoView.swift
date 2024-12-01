//
//  ContentInfoView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/29/24.
//

import UIKit

import SnapKit
import Then

final class ContentInfoView: UIView {
    
    private let contentsStackView = UIStackView()
    
    private let favoriteCountLabel = UILabel()
    private let bookmarkCountLabel = UILabel()
    private let watchCountLabel = UILabel()
    
    private let favoriteImage = UIImageView()
    private let bookmarkImage = UIImageView()
    private let watchImage = UIImageView()
    
    private let favoriteInfoStackView = UIStackView()
    private let bookmarkInfoStackView = UIStackView()
    private let watchInfoStackView = UIStackView()
    private let contentsInfoStackView = UIStackView()
    
//    private let divider = UILabel()
//    private let divider2 = UILabel()
    
    private let divider = UIView()
    private let divider2 = UIView()
    
    init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureData( _ favoriteCount: Int, _ bookmarkCount: Int, _ watchCount: Int, _ isFavorite: Bool, _ isBookmark: Bool) {
        favoriteCountLabel.text = "\(favoriteCount)"
        bookmarkCountLabel.text = "\(bookmarkCount)"
        watchCountLabel.text = "\(watchCount)"
        
        favoriteImage.image = UIImage(resource: isFavorite == true ? .favorite : .unFavorite)
        bookmarkImage.image = UIImage(resource: isBookmark == true ? .bookmark : .unBookmark)
        watchImage.image = UIImage(resource: .visibility)
    }
}

extension ContentInfoView {
    func setupStyle() {
        favoriteImage.do {
//            $0.backgroundColor = .yellow
            $0.contentMode = .scaleAspectFit
        }
        
        bookmarkImage.do {
//            $0.backgroundColor = .yellow
            $0.contentMode = .scaleAspectFit
        }
        
        watchImage.do {
//            $0.backgroundColor = .yellow
            $0.contentMode = .scaleAspectFit
        }
        
        [favoriteCountLabel, bookmarkCountLabel, watchCountLabel].forEach {
            $0.font = .interCaption11()
            $0.textColor = .black30
        }
        
        favoriteInfoStackView.do {
            $0.addArrangedSubviews(favoriteImage, favoriteCountLabel)
            $0.axis = .horizontal
            $0.alignment = .center
        }
        
        bookmarkInfoStackView.do {
            $0.addArrangedSubviews(bookmarkImage, bookmarkCountLabel)
            $0.axis = .horizontal
            $0.alignment = .center
        }
        
        watchInfoStackView.do {
            $0.addArrangedSubviews(watchImage, watchCountLabel)
            $0.axis = .horizontal
            $0.alignment = .center
        }
        
        [favoriteInfoStackView, bookmarkInfoStackView, watchInfoStackView].forEach {
            $0.axis = .horizontal
            $0.spacing = 1
            $0.distribution = .fill
        }
        
        contentsInfoStackView.do {
            $0.addArrangedSubviews(favoriteInfoStackView, divider, bookmarkInfoStackView, divider2, watchInfoStackView)
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fill
            $0.alignment = .center
        }
        
        divider.do {
//            $0.text = "|"
//            $0.textColor = .black30
//            $0.font = .interCaption10()
            $0.backgroundColor = .black30
        }
        
        divider2.do {
//            $0.text = "|"
//            $0.textColor = .black30
//            $0.font = .interCaption10()
            $0.backgroundColor = .black30
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(contentsInfoStackView)
    }
    
    func setupLayout() {
        contentsInfoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(16)
        }
        
        [favoriteImage, bookmarkImage, watchImage].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(16)
            }
        }
        
//        favoriteImage.snp.makeConstraints {
//            $0.width.equalTo(5)
//        }
//        bookmarkImage.snp.makeConstraints {
//            $0.width.equalTo(5)
//        }
//
//        watchImage.snp.makeConstraints {
//            $0.width.equalTo(5)
//        }
    
        divider.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(10)
            $0.centerY.equalToSuperview()
        }

        divider2.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setupDelegate() {
        
    }
}
