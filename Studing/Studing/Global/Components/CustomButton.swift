//
//  CustomButton.swift
//  Studing
//
//  Created by ParkJunHyuk on 9/23/24.
//

import UIKit

final class CustomButton: UIButton {
    
    var buttonAction: (() -> Void)?
    
    var buttonStyle: ButtonStyle
    var buttonState: ButtonState {
        didSet {
            updateButtonState()
        }
    }
    
    var originalColor: UIColor?
    
    init(buttonStyle: ButtonStyle, buttonState: ButtonState = .activate) {
        self.buttonStyle = buttonStyle
        self.buttonState = buttonState
        super.init(frame: .zero)
        setupButton()
        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        var config = UIButton.Configuration.filled()
        
        // 텍스트 설정
        let titleString = AttributedString(buttonStyle.title, attributes: .init(
            [.font: buttonStyle == .studentCard ? UIFont.interBody2() : UIFont.interSubtitle2()]
        ))
        config.attributedTitle = titleString
        config.baseBackgroundColor = buttonState == .deactivate ? buttonStyle.disableBackground : buttonStyle.enableBackground
        config.baseForegroundColor = buttonStyle.foregroundColor
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        originalColor = buttonState == .deactivate ? buttonStyle.disableBackground : buttonStyle.enableBackground
        
        self.configuration = config
        
        switch buttonStyle {
        case .login:
            layer.cornerRadius =  18
        case .studentCard:
            layer.cornerRadius = 12
        case .close, .startDay, .endDay, .startTime, .endTime, .myRanking, .alarmDay, .alarmTime:
            layer.cornerRadius = 10
        case .cancel, .confirm, .delete, .retry:
            layer.cornerRadius = 8
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

// MARK: - Button 애니메이션 관련 Private Extensions

private extension CustomButton {
    func setupAnimation() {
        // TouchDown: 눌렀을 때
        self.addTarget(self, action: #selector(animateTouchDown), for: .touchDown)
        
        // TouchUp, TouchCancel: 손을 뗐을 때
        self.addTarget(self, action: #selector(animateTouchUp), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }
    
    @objc private func animateTouchDown() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.95)
            
            self.configuration?.baseBackgroundColor = self.originalColor?.darken(by: 0.15)
        })
    }
    
    @objc private func animateTouchUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = .identity
            self.configuration?.baseBackgroundColor = self.originalColor
        }, completion: { [weak self] _ in
            // buttonAction이 nil이 아니면 실행
            self?.buttonAction?()
        })
    }
}
