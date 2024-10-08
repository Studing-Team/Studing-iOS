//
//  StudentIdInputCollectionCell.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/8/24.
//

import UIKit

import SnapKit
import Then

final class StudentIdInputCollectionCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let studentIdLabel = UILabel()
    
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

extension StudentIdInputCollectionCell {
    func configureCell(studentId: String) {
        studentIdLabel.text = studentId
    }
    
    func selectedCell() {
        self.backgroundColor = .primary10
        studentIdLabel.textColor = .primary50
        studentIdLabel.font = .interSubtitle2()
    }
    
    func notSelectedCell() {
        self.backgroundColor = .white
        studentIdLabel.textColor = .black50
        studentIdLabel.font = .interBody1()
    }
}

// MARK: - private Extensions

private extension StudentIdInputCollectionCell {
    func setupStyle() {
        studentIdLabel.do {
            $0.font = .interBody1()
            $0.textColor = .black50
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(studentIdLabel)
    }
    
    func setupLayout() {
        studentIdLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }
}
