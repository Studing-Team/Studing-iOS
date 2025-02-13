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
    
    // MARK: - UI Properties
    
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
    
    private let divider = UIView()
    private let divider2 = UIView()
    
    // MARK: - init
    
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
            $0.contentMode = .scaleAspectFit
        }
        
        bookmarkImage.do {
            $0.contentMode = .scaleAspectFit
        }
        
        watchImage.do {
            $0.contentMode = .scaleAspectFit
        }
        
        [favoriteCountLabel, bookmarkCountLabel, watchCountLabel].forEach {
            $0.font = .interCaption11()
            $0.textColor = .black30
        }
        
        favoriteInfoStackView.do {
            $0.addArrangedSubviews(favoriteImage, favoriteCountLabel)
            $0.axis = .horizontal
        }
        
        bookmarkInfoStackView.do {
            $0.addArrangedSubviews(bookmarkImage, bookmarkCountLabel)
            $0.axis = .horizontal
        }
        
        watchInfoStackView.do {
            $0.addArrangedSubviews(watchImage, watchCountLabel)
            $0.axis = .horizontal
        }
        
        [favoriteInfoStackView, bookmarkInfoStackView, watchInfoStackView].forEach {
            $0.axis = .horizontal
            $0.distribution = .fill
        }
        
        contentsInfoStackView.do {
            $0.addArrangedSubviews(favoriteInfoStackView, divider, bookmarkInfoStackView, divider2, watchInfoStackView)
            $0.axis = .horizontal
            $0.spacing = 5
            $0.alignment = .trailing
        }
        
        [divider, divider2].forEach {
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
    
        [divider, divider2].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(0.7)
                $0.centerY.equalToSuperview()
                $0.verticalEdges.equalToSuperview().inset(3)
            }
        }
    }
    
    func setupDelegate() {
        
    }
}
