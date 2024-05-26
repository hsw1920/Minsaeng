//
//  RMViolation.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/26.
//

import Foundation
import RealmSwift

class RMViolation: Object {
    @Persisted var name: String
    @Persisted var phoneNumber: String
}
