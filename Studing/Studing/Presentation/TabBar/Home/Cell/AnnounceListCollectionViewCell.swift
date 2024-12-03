//
//  AnnouceListCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import UIKit

import SnapKit
import Then

enum SelectedAnnounceType {
    case all
    case anthoer
}

final class AnnounceListCollectionViewCell: UICollectionViewCell {
    
    private lazy var selectedAnnounceType: SelectedAnnounceType = .all
    
    private lazy var announceTypeView = AnnounceTypeView()
    private lazy var associationTypeView = AssociationTypeView()
    
    private let contentsImage = AFImageView()
    private let titleLabel = UILabel()
    private let contentsLabel = UILabel()
    
    private let postDayLabel = UILabel()
    private let contentInfoView = ContentInfoView()
    
    private let contentsStackView = UIStackView()
    private let postStackView = UIStackView()
    private let bottomStackView = UIStackView()
    
    // MARK: - init
    
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

extension AnnounceListCollectionViewCell {
    func configureCell(forModel model: AllAssociationAnnounceListEntity) {
        
        selectedAnnounceType = .anthoer
        
        // 기존 뷰들 제거
        self.subviews.forEach { $0.removeFromSuperview() }
        
        // 필요한 뷰들 추가 및 설정
        setupHierarchy()
        setupLayout()
        
        contentsImage.setImage(model.imageUrl, type: .postSmallImage)
        titleLabel.text = "\(model.title)"
        contentsLabel.text = "\(model.contents)"
        
        postDayLabel.text = "\(model.days)"
        contentInfoView.configureData(model.favoriteCount, model.bookmarkCount, model.watchCount, model.isFavorite, model.isBookmark)
        
        announceTypeView.configure(type: model.type)
    }
    
    func configureCell(forModel model: AllAnnounceEntity) {
        
        selectedAnnounceType = .all
        
        // 기존 뷰들 제거
        self.subviews.forEach { $0.removeFromSuperview() }
        
        // 필요한 뷰들 추가 및 설정
        setupHierarchy()
        setupLayout()
        
        contentsImage.setImage(model.imageUrl, type: .postSmallImage)
        titleLabel.text = "\(model.title)"
        contentsLabel.text = "\(model.contents)"
        
        postDayLabel.text = "\(model.days)"
        contentInfoView.configureData(model.favoriteCount, model.bookmarkCount, model.watchCount, model.isFavorite, model.isBookmark)

        associationTypeView.configure(title: model.writerInfo, type: model.associationType)
    }
}

private extension AnnounceListCollectionViewCell {
    func setupStyle() {
        
        self.backgroundColor = .white.withAlphaComponent(0.7)
        self.layer.borderWidth = 1
        self.layer.borderColor =  UIColor.white.cgColor
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        contentsImage.do {
            $0.image = UIImage(resource: .dump)
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.font = .interSubtitle3()
            $0.textColor = .black50
            $0.numberOfLines = 2
        }
        
        contentsLabel.do {
            $0.font = .interBody2()
            $0.textColor = .black50
            $0.numberOfLines = 2
        }
        
        postDayLabel.do {
            $0.font = .interCaption11()
            $0.textColor = .black30
        }
    
        bottomStackView.do {
            $0.addArrangedSubviews(postDayLabel, UIView(), contentInfoView)
            $0.axis = .horizontal
            $0.spacing = 0
            $0.distribution = .fill
            $0.alignment = .center
        }
        
        postStackView.do {
            $0.addArrangedSubviews(titleLabel, contentsLabel)
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .equalSpacing
            $0.alignment = .leading
        }
        
        contentsStackView.do {
            $0.addArrangedSubviews(contentsImage, postStackView)
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fill
            $0.alignment = .leading
        }
    }
    
    func setupHierarchy() {
        switch selectedAnnounceType {
        case .all:
            self.addSubviews(associationTypeView, contentsStackView, bottomStackView)
        case .anthoer:
            self.addSubviews(announceTypeView, contentsStackView, bottomStackView)
        }
    }
    
    func setupLayout() {
        
        if selectedAnnounceType == .all {
            associationTypeView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(10)
                $0.leading.equalToSuperview().inset(15)
            }
            
            contentsStackView.snp.makeConstraints {
                $0.top.equalTo(associationTypeView.snp.bottom).offset(6)
                $0.horizontalEdges.equalToSuperview().inset(15)
            }
        } else {
            announceTypeView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(10)
                $0.leading.equalToSuperview().inset(15)
            }
            
            contentsStackView.snp.makeConstraints {
                $0.top.equalTo(announceTypeView.snp.bottom).offset(6)
                $0.horizontalEdges.equalToSuperview().inset(15)
            }
        }
        
        bottomStackView.snp.makeConstraints {
            $0.top.equalTo(contentsStackView.snp.bottom).offset(9)
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        contentsImage.snp.makeConstraints {
            $0.size.equalTo(83)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        contentsLabel.snp.makeConstraints {
            $0.height.equalTo(37)
        }
    }
}
