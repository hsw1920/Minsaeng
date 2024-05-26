//
//  Violation.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/24.
//

import Foundation

enum Violation: Int, CaseIterable {
    case hydrant = 0
    case intersection
    case busStop
    case crosswalk
    case schoolZone
    case sidewalk
    case etc
    
    var toString: String {
        switch self {
        case .hydrant: "소화전"
        case .intersection: "교차로 모퉁이"
        case .busStop: "버스 정류소"
        case .crosswalk: "횡단보도"
        case .schoolZone: "어린이 보호구역"
        case .sidewalk: "인도"
        case .etc: "기타"
        }
    }

    static func toViolation(_ violation: String) -> Violation {
        switch violation {
        case "소화전": return .hydrant
        case "교차로 모퉁이": return .intersection
        case "버스 정류소": return .busStop
        case "횡단보도": return .crosswalk
        case "어린이 보호구역": return .schoolZone
        case "인도": return .sidewalk
        case "기타": return .etc
        default: return .etc
        }
    }
    
    var description: String {
        switch self {
        case .hydrant: "소화전에 불법주정차"
        case .intersection: "교차로 모퉁이에 불법주정차"
        case .busStop: "버스 정류소에 불법주정차"
        case .crosswalk: "횡단보도에 불법주정차"
        case .schoolZone: "어린이 보호구역에 불법주정차"
        case .sidewalk: "인도에 불법주정차"
        case .etc: "해당 내용으로 불법주정차"
        }
    }
}
