//
//  AgreeTypeView.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/10/24.
//

import UIKit

import SnapKit
import Then

enum AgreeType {
    case essential
    case select
}

final class ArgreeTypeView: UIView {

    // MARK: - Properties
    
    private var type: AgreeType
    
    // MARK: - UI Properties
    
    private let backgroundView = UIView()
    private let agreeView = UILabel()
    
    init(type: AgreeType) {
        self.type = type
        
        super.init(frame: .zero)
        
        setupStyle(type)
        setupHierarchy()
        setupLayout()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ArgreeTypeView {
    func setupStyle(_ type: AgreeType) {
        backgroundView.do {
            $0.backgroundColor = type == .essential ? .black10 : .black30
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black30.cgColor
            $0.layer.cornerRadius = 10
        }
        
        agreeView.do {
            $0.text = type == .essential ? "필수" : "선택"
            $0.textColor = type == .essential ? .black40 : .white
            $0.font = .interCaption10()
        }
    }
    
    func setupHierarchy() {
        addSubviews(backgroundView)
        backgroundView.addSubview(agreeView)
    }
    
    func setupLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(convertByWidthRatio(40))
            $0.height.equalTo(convertByHeightRatio(20))
        }
        
        agreeView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupDelegate() {

    }
}
