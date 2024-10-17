//
//  CustomTabBarViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import UIKit

final class CustomTabBarViewController: UITabBarController {
    
    private let customTabBar = UIView()
    private let customBackgroundTabBar = UIView()
    private var tabbarStackView = UIStackView()
    private var tabButtons = [UIButton]()
    override var selectedIndex: Int {
        didSet {
            updateTabButtonAppearance()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = 0
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegate()
        addTabBarButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        customBackgroundTabBar.do {
            $0.applyRadiusGradient(colors: [.loginStartGradient, .loginEndGradient], direction: .topRightToBottomLeft, locations: [-0.2, 1.3])
        }
    }
}

// MARK: - Private Extensions

extension CustomTabBarViewController {
    func setupStyle() {
        customTabBar.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 64 / 2
        }
        
        tabbarStackView.do {
            $0.axis = .horizontal
            $0.distribution = .equalCentering
            $0.alignment = .center
        }
    }
    
    func setupHierarchy() {
        view.addSubviews(customBackgroundTabBar)
        customBackgroundTabBar.addSubview(customTabBar)
        customTabBar.addSubview(tabbarStackView)
    }
    
    func setupLayout() {
        customBackgroundTabBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(11)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(1)
            $0.height.equalTo(67)
        }
        
        customTabBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(1)
            $0.verticalEdges.equalToSuperview().inset(0.6)
        }
        
        tabbarStackView.snp.makeConstraints {
            $0.edges.equalTo(customTabBar).inset(UIEdgeInsets(top: 6, left: 40, bottom: 6, right: 40))
        }
    }
    
    func addTabBarButtons() {
        for type in TabBarItemType.allCases {
            
            var config = UIButton.Configuration.plain()
            
            let titleString = AttributedString(type.itemName(), attributes: .init([.font: UIFont.interCaption10()]))

            config.image = type.itemIcon().withRenderingMode(.alwaysTemplate)
            config.imagePlacement = .top
            config.imagePadding = 4

            config.attributedSubtitle = titleString

            let button = UIButton(configuration: config)
            button.tag = type.itemTag()
            button.tintColor = .black20

            button.addTarget(self, action: #selector(tabBarButtonTapped(_:)), for: .touchUpInside)

            tabButtons.append(button)
            tabbarStackView.addArrangedSubview(button)
        }
    }
    
    @objc private func tabBarButtonTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
    }
    
    func updateTabButtonAppearance() {
        for (index, button) in tabButtons.enumerated() {
            if index == selectedIndex {
                button.tintColor = .primary50  // 선택된 탭의 색상
                button.configuration?.image?.withTintColor(.primary50)
            } else {
                button.tintColor = .black20   // 선택되지 않은 탭의 색상
                button.configuration?.image?.withTintColor(.black20)
            }
        }
    }
    
    func setupDelegate() {
        
    }
}
