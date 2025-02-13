//
//  DetailAnnouceImagesCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/5/24.
//

import UIKit

import SnapKit
import Then

protocol ImageTappableDelegate: AnyObject {
    func didTapImageView(index: Int)
}

final class DetailAnnouceImagesCollectionViewCell: UICollectionViewCell {
    
    private let contentImageView = AFImageView()
    private var index: Int?
    
    weak var delegate: ImageTappableDelegate?
    
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
    func configureCell(forModel model: DetailAnnouceImageModel, index: Int) {
        contentImageView.setImage(model.image, type: .postImage)
        self.index = index
    }
}

private extension DetailAnnouceImagesCollectionViewCell {
    func setupStyle() {
        contentImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:))))
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(contentImageView)
    }
    
    func setupLayout() {
        contentImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func didTapImageView(_ sender: UITapGestureRecognizer) {
        guard let index else { return }
        delegate?.didTapImageView(index: index)
    }
}
