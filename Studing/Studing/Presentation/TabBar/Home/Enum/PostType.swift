//
//  PostType.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/11/25.
//

import Foundation

enum PostType {
    case announce
    case firstServed
    
    var title: String {
        switch self {
        case .announce:
            return "일반 공지사항 작성하기"
        case .firstServed:
            return "선착순 이벤트 등록하기"
        }
    }
}
