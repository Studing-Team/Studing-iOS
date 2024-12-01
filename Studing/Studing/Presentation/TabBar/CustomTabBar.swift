//
//  CustomTabBar.swift
//  Studing
//
//  Created by ParkJunHyuk on 12/1/24.
//

import UIKit

final class CustomTabBar: UITabBar {
    private let containerView = UIView()
    private let roundedView = UIView()
    private var tabStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // viewDidLayoutSubviews와 같은 역할을 하는 layoutSubviews 추가
    override func layoutSubviews() {
        super.layoutSubviews()

        containerView.applyRadiusGradient(
            colors: [.loginStartGradient, .loginEndGradient],
            direction: .topRightToBottomLeft,
            locations: [-0.2, 1.3]
        )
    }
    
    private func setupStyle() {
        backgroundColor = .clear

        roundedView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 32
        }
        
        tabStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 42
            $0.alignment = .center
        }
    }
    
    private func setupHierarchy() {
        addSubview(containerView)
        containerView.addSubview(roundedView)
        roundedView.addSubview(tabStackView)
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(11)
            $0.bottom.equalToSuperview().inset(28)
            $0.height.equalTo(70)
        }
        
        roundedView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(1)
            $0.verticalEdges.equalToSuperview().inset(0.6)
        }
        
        tabStackView.snp.makeConstraints {
            $0.edges.equalTo(roundedView).inset(UIEdgeInsets(top: 13, left: 40, bottom: 13, right: 40))
        }
    }
    
    func addButton(_ button: UIButton) {
        tabStackView.addArrangedSubview(button)
    }
    
    func updateButtonAppearance(selectedIndex: Int) {
        tabStackView.arrangedSubviews.enumerated().forEach { index, view in
            guard let button = view as? UIButton else { return }
            
            if index == selectedIndex {
                button.tintColor = .primary50
                var updatedConfig = button.configuration
                updatedConfig?.baseForegroundColor = .primary50
                button.configuration = updatedConfig
            } else {
                button.tintColor = .black20
                var updatedConfig = button.configuration
                updatedConfig?.baseForegroundColor = .black20
                button.configuration = updatedConfig
            }
        }
    }
}
