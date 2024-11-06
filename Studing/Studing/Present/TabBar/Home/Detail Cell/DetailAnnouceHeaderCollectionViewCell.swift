//
//  DetailAnnouceHeaderCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/5/24.
//

import UIKit

import SnapKit
import Then

final class DetailAnnouceHeaderCollectionViewCell: UICollectionViewCell {
    
    private let associationLogoImage = UIImageView()
    private let associationName = UILabel()
    private let postDayLabel = UILabel()
    private let contentInfoView = ContentInfoView()
    private let spacerView = UIView()
    
    private let headerStackView = UIStackView()
    private let associationInfoContainerView = UIView()
    private let associationInfoStackView = UIStackView()
    private let bottomStackView = UIStackView()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black5
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailAnnouceHeaderCollectionViewCell {
    func configureCell(forModel model: DetailAnnouceHeaderModel) {
        associationLogoImage.image = UIImage(resource: .allAssociation)
        associationName.text = model.name
        postDayLabel.text = model.days
        
        contentInfoView.configureData(model.favoriteCount,
                                      model.bookmarkCount,
                                      model.watchCount,
                                      model.isFavorite,
                                      model.isBookmark)
    }
}


// MARK: - Extensions

private extension DetailAnnouceHeaderCollectionViewCell {
    func setupStyle() {
        headerStackView.do {
            $0.addArrangedSubviews(associationLogoImage, associationInfoContainerView)
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fill
            $0.alignment = .leading
        }
        
        bottomStackView.do {
            $0.addArrangedSubviews(postDayLabel, contentInfoView)
            $0.axis = .horizontal
            $0.spacing = 35
            $0.distribution = .fillProportionally
        }
        
        postDayLabel.do {
            $0.font = .interCaption11()
            $0.textColor = .black30
            $0.setContentHuggingPriority(.required, for: .horizontal) // 필요한 공간만 차지하도록 우선순위 설정
        }
        
        contentInfoView.do {
            $0.setContentHuggingPriority(.required, for: .horizontal) // 필요한 공간만 차지하도록 우선순위 설정
        }

        spacerView.do {
            $0.backgroundColor = .clear
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal) // 낮은 우선순위로 설정해 남은 공간 차지
        }
        
        associationInfoStackView.do {
            $0.addArrangedSubviews(associationName, bottomStackView)
            $0.axis = .vertical
            $0.spacing = 5
            $0.distribution = .fill
        }
        
        associationName.do {
            $0.font = .interSubtitle3()
            $0.textColor = .black50
        }
        
        postDayLabel.do {
            $0.font = .interCaption10()
            $0.textColor = .black30
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(headerStackView)
        associationInfoContainerView.addSubview(associationInfoStackView)
    }
    
    func setupLayout() {
        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(10)
        }

        associationLogoImage.snp.makeConstraints {
            $0.size.equalTo(55)
        }
        
        associationInfoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
        }
    }
}

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
    
    private let divider = UIView()
    private let divider2 = UIView()
    
    init() {
        super.init(frame: .zero)
        
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(type: AnnouceType) {
        setupStyle(type)
    }
    
    func configureData( _ favoriteCount: Int, _ bookmarkCount: Int, _ watchCount: Int, _ isFavorite: Bool, _ isBookmark: Bool) {
        favoriteCountLabel.text = "\(favoriteCount)"
        bookmarkCountLabel.text = "\(bookmarkCount)"
        watchCountLabel.text = "\(watchCount)"
        
        favoriteImage.image = UIImage(resource: isFavorite == true ? .favorite : .favorite)
        bookmarkImage.image = UIImage(resource: isBookmark == true ? .bookmark : .bookmark)
        watchImage.image = UIImage(resource: .visibility)
    }
}

extension ContentInfoView {
    func setupStyle(_ type: AnnouceType) {
        
        [favoriteCountLabel, bookmarkCountLabel, watchCountLabel].forEach {
            $0.font = .interCaption11()
            $0.textColor = .black30
        }
        
        favoriteInfoStackView.do {
            $0.addArrangedSubviews(favoriteImage, favoriteCountLabel)
        }
        
        bookmarkInfoStackView.do {
            $0.addArrangedSubviews(bookmarkImage, bookmarkCountLabel)
        }
        
        watchInfoStackView.do {
            $0.addArrangedSubviews(watchImage, watchCountLabel)
        }
        
        [favoriteInfoStackView, bookmarkInfoStackView, watchInfoStackView].forEach {
            $0.axis = .horizontal
            $0.spacing = 3
            $0.distribution = .fill
        }
        
        contentsInfoStackView.do {
            $0.addArrangedSubviews(favoriteInfoStackView, divider, bookmarkInfoStackView, divider2, watchInfoStackView)
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .equalCentering
        }
        
        divider.do {
            $0.backgroundColor = .black30
        }
        
        divider2.do {
            $0.backgroundColor = .black30
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(contentsInfoStackView)
    }
    
    func setupLayout() {
        contentsInfoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupDelegate() {
        
    }
}
