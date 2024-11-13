//
//  DetailAnnouceImagesCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/5/24.
//

import UIKit

import SnapKit
import Then

final class DetailAnnouceImagesCollectionViewCell: UICollectionViewCell {
    
    private let contentImageView = UIImageView()
    private let imageCountView = UIView()
    private let imageCountLabel = UILabel()
    
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

extension DetailAnnouceImagesCollectionViewCell {
    func configureCell(forModel model: DetailAnnouceImageModel) {
        imageCountLabel.text = "\(1)/\(3)"
        contentImageView.image = UIImage(resource: .dump)
    }
}

private extension DetailAnnouceImagesCollectionViewCell {
    func setupStyle() {
        contentImageView.do {
            $0.contentMode = .scaleToFill
        }
        
        imageCountLabel.do {
            $0.textColor = .white
            $0.font = .interCaption10()
        }
        
        imageCountView.do {
            $0.backgroundColor = .black50
            $0.layer.cornerRadius = 12
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(contentImageView, imageCountView)
        imageCountView.addSubviews(imageCountLabel)
    }
    
    func setupLayout() {
        contentImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(convertByWidthRatio(335))
        }
        
        imageCountView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.width.equalTo(29)
            $0.height.equalTo(22)
        }
        
        imageCountLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
