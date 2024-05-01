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
