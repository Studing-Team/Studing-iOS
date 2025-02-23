//
//  PostDisplayType.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/22/25.
//

import Foundation

enum PostDisplayType {
    case announce
    case firstCome
    
    var title: String {
        switch self {
        case .announce:
            return "일반 공지사항 작성하기"
        case .firstCome:
            return "선착순 이벤트 등록하기"
        }
    }
}
