//
//  TitleType.swift
//  Studing
//
//  Created by ParkJunHyuk on 1/11/25.
//

import Foundation

enum TitleType: Equatable {
    case title
    case content
    case tag
    case period(type: PostType)
    case personNumber
    
    var title: String {
        switch self {
        case .title:
            return "제목"
        case .content:
            return "내용"
        case .tag:
            return "태그"
        case .period:
            return "기간"
        case .personNumber:
            return "선착순 인원 수"
        }
    }
}
