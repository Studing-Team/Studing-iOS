//
//  String+.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

extension String {
    func formatDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")  // 한국어 로케일 설정
        
        guard let date = dateFormatter.date(from: dateString) else {
            return ""
        }
        
        // 년월일 한글 포맷으로 변환 (월, 일에 0 포함)
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: date)
    }
}
