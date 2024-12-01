//
//  CustomTabBarViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import UIKit

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
        tabBar.isHidden = true
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.shadowImage = nil
        
        setValue(customTabBar, forKey: "tabBar")
        
        view.addSubview(customTabBar)
        
        customTabBar.standardAppearance = appearance
        customTabBar.scrollEdgeAppearance = appearance

        setupCustomTabBar()
        selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            
            // 버튼 width 설정
            button.snp.makeConstraints {
                $0.width.equalTo(80)  // 원하는 너비로 조정
            }

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
