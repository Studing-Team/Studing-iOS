//
//  AssociationTypeView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/13/24.
//

import UIKit

import SnapKit
import Then

final class AssociationTypeView: UIView {
    private var type: AssociationType?
    
    private let backgroundView = UIView()
    private let typeTitleLabel = UILabel()
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero)
        
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, type: AssociationType) {
        setupStyle(type)
        typeTitleLabel.text = title
    }
}

// MARK: - Private Extensions

private extension AssociationTypeView {
    func setupStyle(_ type: AssociationType) {
        backgroundView.do {
            $0.backgroundColor = type.backgroundColor
            $0.layer.cornerRadius = 10
        }
        
        typeTitleLabel.do {
            $0.textColor = type.titleColor
            $0.font = .interSubtitle4()
        }
    }
    
    func setupHierarchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(typeTitleLabel)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        typeTitleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    func setupDelegate() {
        
    }
}
