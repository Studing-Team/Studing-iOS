//
//  PeriodSettingView.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/11/25.
//

import UIKit

import SnapKit
import Then

enum PeriodSettingType {
    case days
    case times
}

final class PeriodSettingView: UIView {
    
    // MARK: - Properties
    
    private let type: PeriodSettingType
    
    // MARK: - UI Properties
    
    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    
    // MARK: - init
    
    init(type: PeriodSettingType) {
        self.type = type
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindingTitle(title: String) {
        titleLabel.text = title
    }
}

// MARK: - Private Extensions

private extension PeriodSettingView {
    func setupStyle() {
        backgroundView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.black10.cgColor
            $0.layer.borderWidth = 1
        }
        
        titleLabel.do {
            $0.textColor = .black30
            $0.font = .interBody1()
        }
    }
    
    func setupHierarchy() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(titleLabel)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(type == .days ? 142 : 78)
            $0.height.equalTo(36)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
    }
    
    func setupDelegate() {
        
    }
}
