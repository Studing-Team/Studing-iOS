//
//  Decodable+.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/19/25.
//

import Foundation

extension Decodable {
    /// 주어진 날짜 문자열을 DateComponents로 변환
    func convertToDateComponents(alarmTime: String?, components: Set<Calendar.Component>) -> DateComponents? {
        guard let alarmTime else { return nil }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "ko_KR")
        inputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let date = inputFormatter.date(from: alarmTime) else { return nil }
        
        let calendar = Calendar(identifier: .gregorian)
        return calendar.dateComponents(components, from: date)
    }
}

