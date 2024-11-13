//
//  DetailAnnouceContentCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/5/24.
//

import UIKit

import SnapKit
import Then

final class DetailAnnouceContentCollectionViewCell: UICollectionViewCell {
    
    private let annouceTypeView = AnnounceTypeView()
    private let contentTitleLabel = UILabel()
    private let contentTextView = UITextView()
    
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

extension DetailAnnouceContentCollectionViewCell {
    func configureCell(forModel model: DetailAnnouceContentModel) {
        contentTitleLabel.text = model.title
        contentTextView.text = model.content
        
        annouceTypeView.configure(type: .annouce)
    }
}

private extension DetailAnnouceContentCollectionViewCell {
    func setupStyle() {
        contentTitleLabel.do {
            $0.textColor = .black50
            $0.font = .interSubtitle2()
            $0.numberOfLines = 2
            $0.contentMode = .top
        }
        
        contentTextView.do {
            $0.textColor = .black50
            $0.backgroundColor = .black5
            $0.font = .interBody2()
            $0.isEditable = false
            $0.isScrollEnabled = true
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(annouceTypeView, contentTitleLabel, contentTextView)
    }
    
    func setupLayout() {
        annouceTypeView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview()//.inset(20)
            $0.height.equalTo(20)
        }
        
        contentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(annouceTypeView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()//.inset(20)
            $0.height.equalTo(55)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentTitleLabel.snp.bottom).offset(1)
            $0.horizontalEdges.equalToSuperview()//.inset(20)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
