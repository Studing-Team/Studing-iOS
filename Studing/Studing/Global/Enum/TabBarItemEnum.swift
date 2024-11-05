//
//  TabBarItemEnum.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import UIKit

enum TabBarItemType: Int, CaseIterable {
    case home, store, mypage
    
    func itemName() -> String {
        switch self {
        case .home: return "홈"
        case .store: return "제휴업체"
        case .mypage: return "마이페이지"
        }
    }
    
    func itemIcon() -> UIImage {
        switch self {
        case .home: return UIImage(resource: .home)
        case .store: return UIImage(resource: .store)
        case .mypage: return UIImage(resource: .mypage)
        }
    }
    
    func itemTag() -> Int {
        switch self {
        case .home: return 0
        case .store: return 1
        case .mypage: return 2
        }
    }
}
