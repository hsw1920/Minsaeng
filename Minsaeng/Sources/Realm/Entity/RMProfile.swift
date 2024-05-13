//
//  RMProfile.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/13.
//

import Foundation
import RealmSwift

class RMProfile: Object {
    @Persisted var name: String
    @Persisted var phoneNumber: String
}

extension RMProfile {
    func asLocal() -> Profile {
        return Profile(name: name,
                       phoneNumber: phoneNumber)
    }
}

extension Profile {
    func asRealm() -> RMProfile {
        return RMProfile.build { object in
            object.name = name
            object.phoneNumber = phoneNumber
        }
    }
}
