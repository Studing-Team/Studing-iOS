//
//  FirstComeButton.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/31/25.
//

import UIKit

enum FirstComeState {
    case wait
    case active
    case joined
    case end
    
    var title: String {
        switch self {
        case .wait, .active:
            return "선착순 이벤트 참여하기"
        case .joined:
            return "내 순위 확인하기"
        case .end:
            return "종료된 이벤트"
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .active:
            return .studingRedButton
        case .joined:
            return .black50
        case .wait, .end:
            return .black20
        }
    }
}

final class FirstComeButton: UIButton {
    
    // MARK: - Properties
    
    private (set)var buttonState: FirstComeState {
        didSet {
            setupButton()
            
            if buttonState == .wait || buttonState == .end {
                self.isUserInteractionEnabled = false
            } else {
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    private var originalColor: UIColor?
    
    var buttonAction: (() -> Void)?
    
    // MARK: - Init
    
    init(buttonState: FirstComeState) {
        self.buttonState = buttonState
        
        super.init(frame: .zero)
        setupButton()
        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func chanageButtonState(buttonState: FirstComeState) {
        self.buttonState = buttonState
    }
}

// MARK: - Private Extensions

private extension FirstComeButton {
    func setupButton() {
        var config = UIButton.Configuration.filled()
        originalColor = buttonState.backgroundColor
        // 텍스트 설정
        let titleString = AttributedString(buttonState.title, attributes: .init(
            [.font: UIFont.interBody2()]
        ))
        config.attributedTitle = titleString
        config.baseBackgroundColor = buttonState.backgroundColor
        config.baseForegroundColor = .white
        
        self.configuration = config
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}

// MARK: - Button 애니메이션 관련 Private Extensions

private extension FirstComeButton {
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
