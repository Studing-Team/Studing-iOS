//
//  CustomMenuViewController.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/14/25.
//

import UIKit

import SnapKit
import Then

protocol MenuButtonActionDelegate: AnyObject {
    func menuButtonTapAction(type: MenuType)
}

final class CustomMenuView: UIView {
    
    // MARK: - Properties
    
    private let menuTypes: [MenuType] = [.edit, .delete]
    private var isMenuVisible = false
    
    weak var delegate: MenuButtonActionDelegate?
    
    // MARK: - UI Properties
    
    private let menuBackgroundView = UIView()
    private let menuListStackView = UIStackView()
    private let editMenuButton = UIButton()
    private let deleteMenuButton = UIButton()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extensions

private extension CustomMenuView {
    func setupStyle() {
        menuBackgroundView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
            $0.layer.shadowColor = UIColor.black30.cgColor
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowRadius = 10
        }
        
        menuListStackView.do {
            $0.axis = .vertical
            $0.distribution = .fillProportionally
            $0.spacing = 0
        }
        
        for (index, menuType) in menuTypes.enumerated() {
            // 메뉴 버튼 추가
            let button = createMenuButton(for: menuType)
            menuListStackView.addArrangedSubview(button)
            
            // Divider 추가 (마지막 버튼에는 추가하지 않음)
            if index < menuTypes.count - 1 {
                let divider = createDivider()
                menuListStackView.addArrangedSubview(divider)
            }
        }
    }
    
    func setupHierarchy() {
        addSubviews(menuBackgroundView)
        menuBackgroundView.addSubviews(menuListStackView)
    }
    
    func setupLayout() {
        menuBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(169)
            $0.height.equalTo(82)
        }
        
        menuListStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func createMenuButton(for menuType: MenuType) -> UIButton {
        let button = UIButton(type: .system)
        
        var config = UIButton.Configuration.plain()
        
        let titleString = AttributedString(menuType.title, attributes: .init(
            [.font: UIFont.interBody1()]
        ))
        
        config.attributedTitle = titleString
        config.image = menuType.menuImage
        config.baseForegroundColor = menuType.textColor
        config.imagePlacement = .trailing // 이미지를 오른쪽에 배치
        config.imagePadding = 50 // 텍스트와 이미지 간 간격
        
        // 버튼 설정 적용
        button.configuration = config
        button.addTarget(self, action: #selector(menuOptionSelected(_:)), for: .touchUpInside)
        
        button.tag = menuTypes.firstIndex(of: menuType) ?? 0
    
        return button
    }
    
    func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .black10
        
        divider.snp.makeConstraints {
            $0.height.equalTo(0.5)
        }
        
        return divider
    }
    
    @objc func menuOptionSelected(_ sender: UIButton) {
        let selectedMenuType = menuTypes[sender.tag]
        print("\(selectedMenuType.title) 선택됨")

        delegate?.menuButtonTapAction(type: selectedMenuType)
    }
}

