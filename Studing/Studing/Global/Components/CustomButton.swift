//
//  CustomButton.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/23/24.
//

import UIKit

enum ButtonState {
    case activate
    case deactivate
}

enum ButtonStyle {
    case next
    case login
    case register
    case authentication
    case notification
    case showStuding
    case duplicate
    case retry
    
    var title: String {
        switch self {
        case .next:
            return "다음"
        case .login:
            return "로그인"
        case .register:
            return "우리 학교 등록하기"
        case .authentication:
            return "인증하기"
        case .notification:
            return "알림 받기"
        case .showStuding:
            return "스튜딩 구경하기"
        case .duplicate:
            return "중복확인"
        case .retry:
            return "다시 시도"
        }
    }
    
    var enableBackground: UIColor {
        switch self {
        case .next, .login, .register, .authentication, .notification, .showStuding, .duplicate, .retry:
            return .primary50
        }
    }
    
    var disableBackground: UIColor {
        switch self {
        case .next, .authentication:
            return .black20
        case .showStuding:
            return .white
        default:
            return .primary50
        }
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .next, .login, .register, .authentication, .notification, .showStuding, .duplicate, .retry:
            return .white
        }
    }
}

class CustomButton: UIButton {
    
    var buttonStyle: ButtonStyle
    var buttonState: ButtonState {
        didSet {
            updateButtonState()
        }
    }
    
    // 초기화 시 buttonStyle과 buttonState를 설정
    init(buttonStyle: ButtonStyle, buttonState: ButtonState = .activate) {
        self.buttonStyle = buttonStyle
        self.buttonState = buttonState
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        var config = UIButton.Configuration.filled()
        
        // 폰트 설정
        let titleString = AttributedString(buttonStyle.title, attributes: .init([.font: UIFont.interSubtitle2()]))
        
        if buttonStyle == .showStuding {
            config.image = UIImage(systemName: "chevron.right")
            config.imagePlacement = .trailing
            config.imagePadding = 10
        }
        
        config.attributedTitle = titleString
        config.baseBackgroundColor = buttonStyle.disableBackground
        config.baseForegroundColor = buttonStyle.foregroundColor
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        self.configuration = config
        
        layer.cornerRadius = buttonStyle == .login ? 18 : 10
        clipsToBounds = true
    }
    
    // 버튼 상태에 따라 스타일 업데이트
    private func updateButtonState() {
        // 활성화 상태에 따라 버튼 클릭 가능 여부 설정
        self.isUserInteractionEnabled = buttonState == .activate
        
        var config = self.configuration ?? UIButton.Configuration.filled()
        
        let titleString = AttributedString(buttonStyle.title,attributes: .init([.font: UIFont.interSubtitle2()]))
        
        config.attributedTitle = titleString
        
        switch buttonState {
        case .activate:
            config.baseBackgroundColor = buttonStyle.enableBackground
            
        case .deactivate:
            config.baseBackgroundColor = buttonStyle.disableBackground
        }
        
        config.baseForegroundColor = buttonStyle.foregroundColor
        self.configuration = config
    }
}
