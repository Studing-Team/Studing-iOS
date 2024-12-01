//
//  UnUserAuthView.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/16/24.
//

import Combine
import UIKit

import SnapKit
import Then

final class UnUserAuthView: UIView {
    
    private let buttonTapPublisher = PassthroughSubject<Void, Never>()
    var buttonTapped: AnyPublisher<Void, Never> {
        buttonTapPublisher.eraseToAnyPublisher()
    }
    
    private let userAuth: UserAuth
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let indicateImageView = UIImageView()
    private let indicateLabel = UILabel()
    
    private var subTitleLabel2 = UILabel()
    private var reSubmittButton = UIButton()
    private var authWaitCheckView: AuthWaitCheckView
    
    // MARK: - init
    
    init(userAuth: UserAuth) {
        self.userAuth = userAuth
        self.authWaitCheckView = AuthWaitCheckView(state: userAuth == .unUser ? .checking : .failure, type: .home)
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupLabel()
        setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension UnUserAuthView {
    func setupStyle() {
        titleLabel.do {
            $0.textColor = .black50
            $0.font = .interHeadline2()
        }
        
        subTitleLabel.do {
            $0.textColor = .black50
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.font = .interCaption12()
        }
        
        indicateLabel.do {
            $0.text = "24시간 이내로 승인 여부를 알려드릴게요!"
            $0.textColor = .black30
            $0.font = .interCaption12()
            $0.textAlignment = .center
        }
        
        indicateImageView.do {
            $0.image = UIImage(resource: .unUserMessage)
            $0.clipsToBounds = true
        }
        
        subTitleLabel2.do {
            $0.textColor = .black50
            $0.text = "학교 인증이 완료된 후에\n스튜딩의 모든 기능을 이용할 수 있어요."
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.font = .interCaption12()
        }
        
        reSubmittButton.do {
            $0.setTitle("학생증 다시 제출하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .interSubtitle2()
            $0.backgroundColor = .primary50
            $0.layer.cornerRadius = 25
            $0.addTarget(self, action: #selector(reSubmitButtonTapped), for: .touchUpInside)
        }
    }
    
    func setupHierarchy() {
        self.addSubviews(titleLabel, subTitleLabel, authWaitCheckView)
        
        if userAuth == .failureUser {
            self.addSubviews(subTitleLabel2, reSubmittButton)
        } else if userAuth == .unUser {
            self.addSubview(indicateImageView)
            indicateImageView.addSubview(indicateLabel)
        }
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        if userAuth == .failureUser {
            subTitleLabel2.snp.makeConstraints {
                $0.top.equalTo(subTitleLabel.snp.bottom).offset(10)
                $0.centerX.equalToSuperview()
            }
            
            authWaitCheckView.snp.makeConstraints {
                $0.top.equalTo(subTitleLabel2.snp.bottom).offset(40)
                $0.centerX.equalToSuperview()
            }
            
            reSubmittButton.snp.makeConstraints {
                $0.top.equalTo(authWaitCheckView.snp.bottom).offset(40)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(self.convertByWidthRatio(238))
                $0.height.equalTo(50)
            }
        } else {
            indicateImageView.snp.makeConstraints {
                $0.top.equalTo(subTitleLabel.snp.bottom).offset(40)
                $0.centerX.equalToSuperview()
            }
            
            indicateLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(8)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-15)
            }
            
            authWaitCheckView.snp.makeConstraints {
                $0.top.equalTo(indicateImageView.snp.bottom).offset(4)
                $0.centerX.equalToSuperview()
//                $0.bottom.equalToSuperview()
            }
        }
    }
    
    func setupLabel() {
        titleLabel.text = userAuth == .unUser ? "학교 인증을 진행 중이에요 :)" : "학교 인증 정보가 일치하지 않아요 :("
        subTitleLabel.text = userAuth == .unUser ? "학교 인증이 완료된 후에\n스튜딩의 모든 기능을 이용할 수 있어요." : "아래 버튼을 통해 학생증 정보를 다시 제출해주세요"
    }
    
    func setupDelegate() {
        
    }
    
    @objc func reSubmitButtonTapped() {
        buttonTapPublisher.send()
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("UnUserAuthView") {
    UnUserAuthView(userAuth: .unUser)
        .showPreview()
}
#endif
