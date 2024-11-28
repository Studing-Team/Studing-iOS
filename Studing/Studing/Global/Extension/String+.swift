//
//  String+.swift
//  Studing
//
//  Created by ParkJunHyuk on 11/11/24.
//

import Foundation

//extension String {
//    func formatDate(from dateString: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        dateFormatter.locale = Locale(identifier: "ko_KR")  // 한국어 로케일 설정
//        
//        guard let date = dateFormatter.date(from: dateString) else {
//            return ""
//        }
//        
//        // 년월일 한글 포맷으로 변환 (월, 일에 0 포함)
//        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
//        return dateFormatter.string(from: date)
//    }
//}

extension String {
    func formatDate(from dateString: String) -> String {
//        // 소수점이 있는 경우
//        if dateString.contains(".") {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
//            
//            guard let date = dateFormatter.date(from: dateString) else { return "" }
//            
//            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
//            dateFormatter.locale = Locale(identifier: "ko_KR")
//            return dateFormatter.string(from: date)
//        }
//        // 소수점이 없는 경우
//        else {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//            
//            guard let date = dateFormatter.date(from: dateString) else { return "" }
//            
//            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
//            dateFormatter.locale = Locale(identifier: "ko_KR")
//            return dateFormatter.string(from: date)
//        }
        
        // "2024-11-02"와 같은 형식의 문자열을 Date 객체로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else { return "" }
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: date)
            
//            if let date = dateFormatter.date(from: dateString) {
//                // 변환된 Date 객체를 원하는 형식으로 변환
//                dateFormatter.dateFormat = "yyyy년 MM월 dd일"
//                return dateFormatter.string(from: date)
//            }
    }
}
