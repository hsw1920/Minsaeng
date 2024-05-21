//
//  Complaint.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/20.
//

import Foundation

struct Complaint {
    let idx: Int = 0
    let image: String
    let violationType: Violation
    let date: Date
    
    static let list: [Complaint] = [
        Complaint(image: "1", violationType: .crosswalk, date: Date()),
        Complaint(image: "2", violationType: .busStop, date: Date()),
        Complaint(image: "3", violationType: .etc, date: Date()),
        Complaint(image: "4", violationType: .crosswalk, date: Date()),
        Complaint(image: "5", violationType: .hydrant, date: Date()),
    ]
}
