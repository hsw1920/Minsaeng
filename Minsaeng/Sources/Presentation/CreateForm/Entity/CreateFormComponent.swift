//
//  CreateFormComponent.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/24.
//

import Foundation

protocol CreateFormComponent {
    var violationType: Violation { get }
    var vehicleNumber: String { get }
    var date: Date { get }
    var profile: Profile { get }
}

struct CreateFormComponentImpl: CreateFormComponent {
    let violationType: Violation
    let vehicleNumber: String
    let detailContent: String
    let date: Date
    let profile: Profile
    let imageData: Data?
    let isReceived: Bool
    
    init(vehicleNumber: String,
         violationType: Violation,
         detailContent: String,
         date: Date = .now,
         profile: Profile,
         isReceived: Bool,
         imageData: Data?) {
        self.violationType = violationType
        self.vehicleNumber = vehicleNumber
        self.detailContent = detailContent
        self.date = date
        self.profile = profile
        self.isReceived = isReceived
        self.imageData = imageData
    }
}
