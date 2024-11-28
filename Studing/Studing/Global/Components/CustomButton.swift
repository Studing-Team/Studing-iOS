//
//  CustomButton.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/23/24.
//

import UIKit

final class CustomButton: UIButton {
    
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
        let titleString = AttributedString(buttonStyle.title, attributes: .init(
            [.font: buttonStyle == .studentCard ? UIFont.interBody2() : UIFont.interSubtitle2()]
        ))

        config.attributedTitle = titleString
        config.baseBackgroundColor = buttonStyle.disableBackground
        config.baseForegroundColor = buttonStyle.foregroundColor
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        self.configuration = config
        
        switch buttonStyle {
        case .login:
            layer.cornerRadius =  18
        case .studentCard:
            layer.cornerRadius = 12
        default:
            layer.cornerRadius = 24
        }
        
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
