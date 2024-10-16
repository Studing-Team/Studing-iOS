//
//  AuthWaitCheckView.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/15/24.
//

import UIKit

import SnapKit
import Then

final class AuthWaitCheckView: UIView {
    
    // MARK: - Properties
    
    private var state: AuthWaitState = .summit
    
    // MARK: - UI Properties
    
    private let summitTitleLabel = UILabel()
    private let checkTitleLabel = UILabel()
    private let completeTitleLabel = UILabel()
    
    private let titleStackView = UIStackView()
    private let imageStackView = UIStackView()
    
    private let summitStackView = UIStackView()
    private let checkStackView = UIStackView()
    private let completeStackView = UIStackView()
    
    private let summitImageView = UIImageView()
    private let checkImageView = UIImageView()
    private let checkingImageView = UIImageView()
    private let completeImageView = UIImageView()
    
    private let lineView1 = UIView()
    private let lineView2 = UIView()
    
    // MARK: - Life Cycle
    
    init() {
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

// MARK: - Private Extensions

extension AuthWaitCheckView {
    func updateWaitState(_ authWaitState: AuthWaitState) {
        self.state = authWaitState
    }
}

// MARK: - Private Extensions

private extension AuthWaitCheckView {
    func setupStyle() {
        summitTitleLabel.do {
            $0.text = "제출 완료"
            $0.font = state.font(step: 1)
            $0.textColor = state.fontColor(step: 1)
        }
        
        checkTitleLabel.do {
            $0.text = "확인 중"
            $0.font = state.font(step: 2)
            $0.textColor = state.fontColor(step: 2)
        }
        
        completeTitleLabel.do {
            $0.text = state.rawValue == 5 ? "승인 실패" : "승인 완료"
            $0.font = state.font(step: 4)
            $0.textColor = state.fontColor(step: 4)
        }
        
        summitImageView.do {
            $0.image = state.stateImage(step: 1)
            $0.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            $0.clipsToBounds = true
        }
        
        checkImageView.do {
            if state.rawValue <= 2 {
                $0.image = state.stateImage(step: 2)
            } else if state.rawValue <= 5 {
                $0.image = state.stateImage(step: 3)
            }
            
            $0.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            $0.clipsToBounds = true
        }
        
        completeImageView.do {
            if state.rawValue == 4 {
                $0.image = state.stateImage(step: 4)
            } else {
                $0.image = state.stateImage(step: 5)
            }
            
            $0.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            $0.clipsToBounds = true
        }
        
        summitStackView.do {
            $0.axis = .vertical
            $0.distribution = .equalCentering
            $0.alignment = .center
            $0.spacing = 16
            $0.addArrangedSubviews(summitImageView, summitTitleLabel)
        }

        
        checkStackView.do {
            $0.axis = .vertical
            $0.distribution = .equalCentering
            $0.alignment = .center
            $0.spacing = state.rawValue == 2 ? 16 : 12
            $0.addArrangedSubviews(checkImageView, checkTitleLabel)
        }

        completeStackView.do {
            $0.axis = .vertical
            $0.distribution = .equalCentering
            $0.alignment = .center
            $0.spacing = 16
            $0.addArrangedSubviews(completeImageView, completeTitleLabel)
        }
        
        lineView1.do {
            $0.backgroundColor = state.rawValue >= 2 ? .primary50 : .black10
        }
        
        lineView2.do {
            $0.backgroundColor = state.rawValue >= 4 ? .primary50 : .black10
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(lineView1, lineView2, summitStackView, checkStackView, completeStackView)
    }
    
    func setupLayout() {
        summitStackView.snp.makeConstraints {
            if state.rawValue == 2 {
                $0.top.equalToSuperview().offset(4)
            } else {
                $0.top.equalToSuperview()
            }
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        lineView1.snp.makeConstraints {
            if state.rawValue == 2 {
                $0.top.equalToSuperview().offset(20)
            } else {
                $0.top.equalToSuperview().offset(16)
            }
            $0.leading.equalTo(summitStackView.snp.trailing).offset(-16)
            $0.trailing.equalTo(checkStackView.snp.trailing).offset(16)
            $0.height.equalTo(2)
        }
        
        checkStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(summitStackView.snp.trailing).offset(convertByWidthRatio(74))
            $0.bottom.equalToSuperview()
        }
        
        lineView2.snp.makeConstraints {
            if state.rawValue == 2 {
                $0.top.equalToSuperview().offset(20)
            } else {
                $0.top.equalToSuperview().offset(16)
            }
            $0.leading.equalTo(checkStackView.snp.trailing).offset(-16)
            $0.trailing.equalTo(completeStackView.snp.leading).offset(16)
            $0.height.equalTo(2)
        }
        
        completeStackView.snp.makeConstraints {
            if state.rawValue == 2 {
                $0.top.equalToSuperview().offset(4)
            } else {
                $0.top.equalToSuperview()
            }
            $0.leading.equalTo(checkStackView.snp.trailing).offset(convertByWidthRatio(74))
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupDelegate() {

    }
}
