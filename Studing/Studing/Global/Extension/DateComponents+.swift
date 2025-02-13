//
//  DateComponents+.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/13/25.
//

import Foundation

extension DateComponents {
    func convertToStringDayFormat() -> String {
        guard let year = self.year,
              let month = self.month,
              let day = self.day else { return "" }
        
        let dateString = String(format: "%d년 %d월 %d일", year, month, day)
        
        return dateString
    }
}
