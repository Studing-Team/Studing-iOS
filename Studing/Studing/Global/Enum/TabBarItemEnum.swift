//
//  TabBarItemEnum.swift
//  Studing
//
//  Created by ParkJunHyuk on 10/17/24.
//

import UIKit

/// `TabBarItemType` 열거형은 앱의 탭 바에 표시될 항목을 정의합니다.
/// 각 항목은 홈(.home), 제휴업체(.store), 마이페이지(.mypage)로 구성되며,
/// 탭 바에서 사용할 이름, 아이콘, 태그와 관련된 기능을 제공합니다.
///
/// - Note: `CaseIterable` 프로토콜을 채택하여 모든 case를 순회할 수 있습니다.
///
/// ## 열거형의 각 케이스
///   - `home`: 홈 화면을 나타냅니다.
///   - `store`: 제휴업체 화면을 나타냅니다.
///   - `mypage`: 마이페이지 화면을 나타냅니다.
///
enum TabBarItemType: Int, CaseIterable {
    /// 홈 화면
    case home
    
    /// 제휴업체 화면
    case store
    
    /// 마이페이지 화면
    case mypage
    
    /// 탭 바 항목의 이름을 반환합니다.
    ///
    /// - Returns: 탭 바에 표시될 항목의 이름
    func itemName() -> String {
        switch self {
        case .home: return "홈"
        case .store: return "제휴업체"
        case .mypage: return "마이페이지"
        }
    }
    
    /// 탭 바 항목의 아이콘을 반환합니다.
    ///
    /// - Returns: 해당 항목의 아이콘
    func itemIcon() -> UIImage {
        switch self {
        case .home: return UIImage(resource: .home)
        case .store: return UIImage(resource: .store)
        case .mypage: return UIImage(resource: .mypage)
        }
    }
    
    /// 탭 바 항목의 태그를 반환합니다.
    ///
    /// - Returns: 탭 바에서 항목을 구분하는 태그
    func itemTag() -> Int {
        switch self {
        case .home: return 0
        case .store: return 1
        case .mypage: return 2
        }
    }
}
