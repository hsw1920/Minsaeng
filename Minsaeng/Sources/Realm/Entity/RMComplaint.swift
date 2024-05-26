//
//  RMComplaint.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/26.
//

import Foundation
import RealmSwift

class RMComplaint: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var requiredImage: String
    @Persisted var optionalImage: String?
    @Persisted var violationType: String
    @Persisted var date: Date
    @Persisted var location: String
    @Persisted var detailContent: String
}

extension RMComplaint {
    func asLocal() -> Complaint {
        return Complaint(id: id,
                         requiredImage: requiredImage,
                         optionalImage: optionalImage,
                         violationType: Violation.toViolation(violationType),
                         date: date, 
                         location: location,
                         detailContent: detailContent)
    }
    
    func asLocalRecentComplaint() -> RecentComplaint {
        return RecentComplaint(image: requiredImage, 
                               violationType: Violation.toViolation(violationType),
                               date: date)
    }
}

extension Complaint {
    func asRealm() -> RMComplaint {
        return RMComplaint.build { object in
            object.id = id
            object.requiredImage = requiredImage
            object.optionalImage = optionalImage
            object.violationType = violationType.toString
            object.date = date
            object.location = location
            object.detailContent = detailContent
        }
    }
}

