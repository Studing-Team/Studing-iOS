//
//  TimeListCollectionViewCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/10/25.
//

import UIKit

import SnapKit
import Then

final class TimeListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var isSelectMyRank: Bool? {
        didSet {
            if let isSelectMyRank {
                if isSelectMyRank == true {
                    changeSelectToCell(isSelectMyRank)
                }
            }
        }
    }
    
    // MARK: - UI Components
    
    private let backgroundCellView = UIView()
    private let timeDataStackView = UIStackView()
    private let orderLabel = UILabel()
    private let timeLabel = UILabel()
    private let studentNumberLabel = UILabel()

    // MARK: - Init
    
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

extension TimeListCollectionViewCell {
    func configureCell(for model: FirstComeRankingsModel) {
        orderLabel.text = model.orderNumber
        timeLabel.text = model.applyDateTime
        studentNumberLabel.text = model.maskedStudentNumber
    }
    
    func selectMyRankToCell(_ isSelect: Bool) {
        self.isSelectMyRank = isSelect
    }
}

// MARK: - Private Extensions

private extension TimeListCollectionViewCell {
    func setupStyle() {
        timeDataStackView.do {
            $0.axis = .horizontal
            $0.spacing = 3
            $0.alignment = .center
            $0.distribution = .fillProportionally
            $0.isLayoutMarginsRelativeArrangement = true
            $0.addArrangedSubviews(orderLabel, timeLabel, studentNumberLabel)
        }
        
        orderLabel.do {
            $0.font = .interBody3()
            $0.textColor = .black40
            $0.textAlignment = .center
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        timeLabel.do {
            $0.font = .interBody3()
            $0.textColor = .black40
            $0.textAlignment = .center
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        studentNumberLabel.do {
            $0.font = .interBody3()
            $0.textColor = .black40
            $0.textAlignment = .center
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
    }
    
    func setupHierarchy() {
        self.addSubview(backgroundCellView)
        backgroundCellView.addSubviews(timeDataStackView)
    }
    
    func setupLayout() {
        backgroundCellView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        timeDataStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(convertByWidthRatio(12))
            $0.leading.equalToSuperview().offset(19)
            $0.trailing.equalToSuperview().inset(25)
        }
        
        orderLabel.snp.makeConstraints {
            $0.width.equalTo(24)
        }
        
        studentNumberLabel.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(self.convertByWidthRatio(63))
        }
    }
    
    func changeSelectToCell(_ isSelect: Bool) {
        if isSelect {
            self.backgroundCellView.backgroundColor = .red5
            
            [orderLabel, timeLabel, studentNumberLabel].forEach {
                $0.textColor = .studingRedButton
            }
            
        } else {
            self.backgroundCellView.backgroundColor = .clear
            
            [orderLabel, timeLabel, studentNumberLabel].forEach {
                $0.textColor = .black40
            }
        }
    }
}
