//
//  CategoryType.swift
//  Studing
//
//  Created by ParkJunHyuk on 12/12/24.
//

import UIKit

/// `CategoryType` 열거형은 제휴 업체를 유형별로 구분하기 위한 구조를 제공합니다.
///
/// - Note: `CaseIterable` 프로토콜을 채택하여 모든 case를 순회할 수 있습니다.
/// `.all` case 경우 icon을 갖고 있지 않습니다.
///
/// ## 주요 목적
/// - 사용자가 다양한 제휴 업체를 카테고리별로 탐색할 수 있도록 도움.
/// - 카테고리별로 적절한 UI 요소(예: 텍스트, 아이콘)를 제공하기 위한 정보를 포함.
/// - title, icon 변수를 통해 제휴업체의 제목과 아이콘을 사용.
///
/// ## 열거형의 각 케이스
/// - `all`: **모든 카테고리**를 대표합니다. 주로 필터링 초기 상태나 전체 보기 기능에서 사용됩니다.
/// - `restaurant`: **음식점** 카테고리를 나타냅니다.
///   음식점 관련 제휴 업체를 찾을 때 활용됩니다.
/// - `coffee`: **카페** 카테고리를 나타냅니다.
///   카페 제휴 업체를 찾을 떄 활용됩니다.
/// - `bar`: **주점** 카테고리를 나타냅니다.
///   주점 관련 제휴 업체를 탐색할 때 활용됩니다.
/// - `exercise`: **운동**을 나타냅니다.
///   헬스장, 요가 스튜디오 등 운동 관련 제휴 업체를 탐색할 때 활용됩니다.
/// - `health`: **병원**이나 의료 관련 업체를 나타냅니다.
///   병원, 약국 등 의료 서비스 관련 제휴 업체를 찾을때 활용됩니다.
/// - `culture`: **문화**을 나타냅니다.
///   문화 관련 제휴 업체를 찾을 때 활용됩니다.
///
enum CategoryType: CaseIterable {
    case all
    case restaurant
    case coffee
    case bar
    case exercise
    case health
    case culture
    
    var title: String {
        switch self {
        case .all:
            return "전체"
        case .restaurant:
            return "음식점"
        case .coffee:
            return "카페"
        case .culture:
            return "문화"
        case .health:
            return "병원"
        case .bar:
            return "주점"
        case .exercise:
            return "운동"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .all:
            return nil
        case .restaurant:
            return UIImage(resource: .restaurant)
        case .coffee:
            return UIImage(resource: .coffee)
        case .culture:
            return UIImage(resource: .culture)
        case .health:
            return UIImage(resource: .health)
        case .bar:
            return UIImage(resource: .bar)
        case .exercise:
            return UIImage(resource: .exercise)
        }
    }
}

