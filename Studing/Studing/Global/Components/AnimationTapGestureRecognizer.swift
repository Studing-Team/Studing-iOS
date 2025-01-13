//
//  AnimationTapGestureRecognizer.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/11/25.
//

import UIKit

final class AnimationTapGestureRecognizer: UILongPressGestureRecognizer {
    
    // MARK: - Properties
    
    private let tapCompletionHandler: (() -> Void)?
    private var originalColor: UIColor?
    
    // MARK: - init
    
    init(target: UIView, completion: (() -> Void)?) {
        self.tapCompletionHandler = completion
        super.init(target: nil, action: nil)
        
        self.minimumPressDuration = 0
        self.addTarget(self, action: #selector(handleGesture(_:)))
        self.originalColor = target.backgroundColor
    }
    
    @objc private func handleGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let view = gesture.view else { return }
        
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.1) {
                view.transform = CGAffineTransform(scaleX: 0.97, y: 0.95)
                if let currentColor = self.originalColor {
                    view.backgroundColor = currentColor.darken(by: 0.05)
                }
            }
        case .ended:
            UIView.animate(withDuration: 0.1) {
                view.transform = .identity
                view.backgroundColor = self.originalColor
            } completion: { _ in
                self.tapCompletionHandler?()
            }
        case .cancelled:
            UIView.animate(withDuration: 0.1) {
                view.transform = .identity
                view.backgroundColor = self.originalColor
            }
        default:
            break
        }
    }
}

protocol TappableView: UIView {
    func addTapAnimation(completion: (() -> Void)?)
}

extension TappableView {
    func addTapAnimation(completion: (() -> Void)? = nil) {
        // 제스처 추가
        let gesture = AnimationTapGestureRecognizer(target: self, completion: completion)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
}
