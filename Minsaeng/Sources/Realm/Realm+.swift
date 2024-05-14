//
//  Realm+.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/13.
//

import Foundation
import RealmSwift

extension Object {
    static func build<O: Object>(_ builder: (O) -> () ) -> O {
        let object = O()
        builder(object)
        return object
    }
}
