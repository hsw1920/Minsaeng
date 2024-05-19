//
//  MSDateFormatter.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/19.
//

import Foundation

final class MSDateFormatter {
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    func getY4M2D4(date: Date) -> String {
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
}
