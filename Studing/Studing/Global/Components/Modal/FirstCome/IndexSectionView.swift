//
//  IndexSectionView.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/24/25.
//

import UIKit

import SnapKit
import Then

final class IndexSectionView: UIView {
   
    // MARK: - UI Properties
    
    private let indexSectionStackView = UIStackView()
    private let orderLabel = UILabel()
    private let timeLabel = UILabel()
    private let studentNumberLabel = UILabel()
    
    // MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension IndexSectionView {
    func setupStyle() {
        indexSectionStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fillProportionally
            $0.addArrangedSubviews(orderLabel, timeLabel, studentNumberLabel)
        }
        
        orderLabel.do {
            $0.font = .interSubtitle2()
            $0.textColor = .black40
            $0.text = "순번"
        }
        
        timeLabel.do {
            $0.font = .interSubtitle2()
            $0.textColor = .black40
            $0.text = "시간"
        }
        
        studentNumberLabel.do {
            $0.font = .interSubtitle2()
            $0.textColor = .black40
            $0.text = "학번"
        }
    }
    
    func setupHierarchy() {
        addSubviews(orderLabel, timeLabel, studentNumberLabel)
    }
    
    func setupLayout() {
        orderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(convertByWidthRatio(19))
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(orderLabel)
            $0.leading.equalTo(orderLabel.snp.trailing).offset(convertByWidthRatio(76))
        }
        
        studentNumberLabel.snp.makeConstraints {
            $0.centerY.equalTo(orderLabel)
            $0.leading.equalTo(timeLabel.snp.trailing).offset(convertByWidthRatio(109))
            $0.trailing.equalToSuperview().inset(convertByWidthRatio(48))
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("IndexSectionView") {
    IndexSectionView()
        .showPreview()
}
#endif
