//
//  CustomTabBarViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import UIKit

final class CustomTabBarViewController: UITabBarController {
    
    private lazy var customTabBar: CustomTabBar = CustomTabBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70))
    
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

        
//        var tabFrame = tabBar.frame
//        tabFrame.size.height = 98  // 70 + 28
//        tabFrame.origin.y = view.frame.size.height - 98
//        tabBar.frame = tabFrame
        
//        tabBar.items?.forEach { item in
//            item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
        
        
        setupCustomTabBar()
        selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTabButtonAppearance()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        var tabFrame = tabBar.frame
//        tabFrame.size.height = 98  // 70 + 28
//        tabFrame.origin.y = view.frame.size.height - 98
//        tabBar.frame = tabFrame
//        
//        tabBar.items?.forEach { item in
//            item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
//    }

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
