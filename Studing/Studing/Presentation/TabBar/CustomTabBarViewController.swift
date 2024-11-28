//
//  CustomTabBarViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
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
            $0.distribution = .equalSpacing
            $0.alignment = .center
            $0.spacing = 20
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
            $0.height.equalTo(67)
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

final class CustomTabBarViewController: UITabBarController {
    
    private lazy var customTabBar: CustomTabBar = CustomTabBar()
    
    private var isTabBarSetup = false
    
    // selectedIndex가 변경될 때마다 호출되도록 override
    override var selectedIndex: Int {
        didSet {
            print(selectedIndex)
            updateTabButtonAppearance()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.shadowImage = nil
        
        setValue(customTabBar, forKey: "tabBar")
        
        customTabBar.standardAppearance = appearance
        customTabBar.scrollEdgeAppearance = appearance
        
        setupCustomTabBar()
        selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        selectedIndex = 0
        
        updateTabButtonAppearance()
    }

    private func setupCustomTabBar() {
        
        guard !isTabBarSetup else { return }
        
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

            customTabBar.addButton(button)
        }
        
        isTabBarSetup = true
    }

    private func updateTabButtonAppearance() {
        customTabBar.updateButtonAppearance(selectedIndex: selectedIndex)
   }
}

// UITabBarControllerDelegate 구현
extension CustomTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateTabButtonAppearance()
    }
}
