//
//  Complaint.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/20.
//

import Foundation

struct Complaint {
    let id: UUID
    let requiredImage: String
    let optionalImage: String?
    let violationType: Violation
    let date: Date
    let location: String
    let detailContent: String
}
