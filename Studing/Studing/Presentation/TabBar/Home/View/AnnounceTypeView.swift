//
//  AnnouceTypeView.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/21/24.
//

import UIKit

import SnapKit
import Then

final class AnnounceTypeView: UIView {
    
    private var type: AnnounceType?
    
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
    
    func configure(type: AnnounceType) {
        setupStyle(type)
    }
}

// MARK: - Private Extensions

private extension AnnounceTypeView {
    func setupStyle(_ type: AnnounceType) {
        backgroundView.do {
            $0.backgroundColor = .clear
            $0.layer.borderColor = type.backgroundColor.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 10
        }
        
        typeTitleLabel.do {
            $0.text = type.title
            $0.textColor = type.titleColor
            $0.font = .interChips12()
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
