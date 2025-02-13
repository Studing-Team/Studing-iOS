//
//  CircularLoadingView.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/6/25.
//

import UIKit

final class CircularLoadingView: UIView {
    
    // MARK: - Properties
    
    
    // MARK: - UI Properties
    
    private let circleCount = 8
    private let circleViews: [UIView] = []
    
    // MARK: - Life Cycle
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCircles()
        startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCircles() {
        let radius: CGFloat = 15
        let centerX = bounds.width / 2
        let centerY = bounds.height / 2
        
        for i in 0..<circleCount {
            let circle = UIView()
            circle.backgroundColor = .primary50.withAlphaComponent(0.2)
            circle.layer.cornerRadius = 4
            
            let angle = (2 * .pi * CGFloat(i)) / CGFloat(circleCount)
            let x = centerX + radius * cos(angle)
            let y = centerY + radius * sin(angle)
            
            circle.frame = CGRect(x: x - 4, y: y - 4, width: 7, height: 7)
            addSubview(circle)
        }
    }
    
    func startAnimating() {
        for (index, circle) in subviews.enumerated() {
            let delay = Double(index) * (1.0 / Double(circleCount))
            
            UIView.animate(withDuration: 0.8,
                         delay: delay,
                         options: [.repeat, .curveEaseInOut],
                         animations: {
                circle.backgroundColor = .primary50
            }, completion: { _ in
                circle.backgroundColor = .primary50.withAlphaComponent(0.2)
            })
        }
    }
    
    func stopAnimating() {
        circleViews.forEach { $0.layer.removeAllAnimations() }
    }
}

// MARK: - Private Extensions

private extension CircularLoadingView {
    func setupStyle() {
        
    }

    func setupHierarchy() {
        
    }
    
    func setupLayout() {
        
    }
    
    func setupDelegate() {

    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview("CircularLoadingView") {
    CircularLoadingView()
        .showPreview()
}
#endif

class CustomRefreshControl: UIRefreshControl {
    private var loadingView: CircularLoadingView?
    
    override init() {
        super.init()
        setupLoadingView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLoadingView() {
        // 레이아웃이 완료된 후에 loadingView 설정
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingView = CircularLoadingView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            if let loadingView = self.loadingView {
                loadingView.center = CGPoint(x: self.frame.width / 2, y: 25)
                self.addSubview(loadingView)
            }
        }
        tintColor = .clear
    }
}
