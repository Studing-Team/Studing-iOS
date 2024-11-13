//
//  StudingHeaderView.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import UIKit

import SnapKit
import Then

enum StudingHeaderType {
    case home
    case mypage
}

final class StudingHeaderView: UIView {

    // MARK: - Properties
    
    private let type: StudingHeaderType
    
    // MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private lazy var alarmImageView = UIImageView()
    
    // MARK: - init
    
    init(type: StudingHeaderType) {
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
}

extension StudingHeaderView {
    func setupStyle() {
        
        self.backgroundColor = .clear
        
        titleLabel.do {
            $0.text = type == .home ? StringLiterals.Header.nameTitle : StringLiterals.Header.mypateTItle
            $0.textColor = .black50
            $0.font = type == .home ? .montserratAlternatesBold(size: 28) : .interSubtitle1()
        }
        
        alarmImageView.do {
            $0.image = UIImage(resource: .alarm)
            $0.contentMode = .scaleToFill
        }
    }
    
    func setupHierarchy() {
        switch type {
        case .home:
            self.addSubviews(titleLabel)
        case .mypage:
            self.addSubviews(titleLabel, alarmImageView)
        }
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        if type == .mypage {
            alarmImageView.snp.makeConstraints {
//                $0.verticalEdges.equalToSuperview().inset(18)
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(20)
                $0.width.equalTo(16)
                $0.height.equalTo(20)
            }
        }
    }
    
    func setupDelegate() {

    }
}
