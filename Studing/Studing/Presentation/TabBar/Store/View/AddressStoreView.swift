//
//  AddressStoreView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/28/24.
//

import UIKit

import SnapKit
import Then

final class AddressStoreView: UIView {
    
    // MARK: - UI Properties
    
    private let backgroundView = UIView()
    private let addressTitleLabel = UILabel()
    private let addressImage = UIImageView()
    private let backButton = UIButton()
    
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
    
    func configure(address: String) {
        self.addressTitleLabel.text = address
    }
}

// MARK: - Private Extensions

private extension AddressStoreView {
    func setupStyle() {
        backgroundView.do {
            $0.backgroundColor = .white.withFigmaStyleAlpha(0.7)
            $0.layer.cornerRadius = 24
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1
        }
        
        backButton.do {
            $0.setImage(.backStore, for: .normal)
            $0.backgroundColor = .white.withFigmaStyleAlpha(0.7)
            $0.layer.shadowColor = UIColor.black40.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)  // 그림자 위치
            $0.layer.shadowOpacity = 0.2  // 그림자 투명도
            $0.layer.shadowRadius = 6  // 그림자 퍼짐 정도
        }
        
        addressTitleLabel.do {
            $0.font = .interBody2()
            $0.textColor = .black50
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
        
        addressImage.do {
            $0.image = UIImage(resource: .storeLocation)
        }
    }
    
    func setupHierarchy() {
        addSubviews(backgroundView)
        backgroundView.addSubviews(addressTitleLabel, addressImage)
        
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        addressTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            $0.trailing.equalTo(addressImage.snp.leading).inset(15)
        }
 
        addressImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
        }
    }
}
