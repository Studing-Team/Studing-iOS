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
    
    private let contentImageView = AFImageView()
    
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
        contentImageView.setImage(model.image, type: .postImage)
    }
}

private extension DetailAnnouceImagesCollectionViewCell {
    func setupStyle() {
        contentImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(contentImageView)
    }
    
    func setupLayout() {
        contentImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
//            $0.size.equalTo(convertByWidthRatio(335))
        }
    }
}
