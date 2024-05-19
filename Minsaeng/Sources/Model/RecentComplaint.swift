//
//  RecentComplaint.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/19.
//

import Foundation

struct RecentComplaint {
    let image: String
    let violationType: Violation
    let date: Date
    
    static let list: [RecentComplaint] = [
        RecentComplaint(image: "1", violationType: .crosswalk, date: Date()),
        RecentComplaint(image: "2", violationType: .busStop, date: Date()),
        RecentComplaint(image: "3", violationType: .etc, date: Date()),
        RecentComplaint(image: "4", violationType: .crosswalk, date: Date()),
        RecentComplaint(image: "5", violationType: .hydrant, date: Date()),
        RecentComplaint(image: "6", violationType: .sidewalk, date: Date()),
        RecentComplaint(image: "7", violationType: .schoolZone, date: Date())
    ]
}
