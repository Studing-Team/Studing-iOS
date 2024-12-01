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
    
    private let associationLogoImage = AFImageView()
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
        associationLogoImage.setImage(model.image, type: .associationLogo)
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
        
        associationLogoImage.do {
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 55 / 2
            $0.clipsToBounds = true
        }
        
        bottomStackView.do {
            $0.addArrangedSubviews(postDayLabel, UIView(), contentInfoView)
            $0.axis = .horizontal
            $0.spacing = 0
            $0.distribution = .fill
            $0.alignment = .center
        }
        
        postDayLabel.do {
            $0.font = .interCaption11()
            $0.textColor = .black30
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
