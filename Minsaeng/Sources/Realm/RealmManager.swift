//
//  RealmManager.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/13.
//

import Foundation
import RealmSwift

final class RealmManager {
    private let realm = try! Realm()
    
    // CREATE
    func createItem<T: Object>(_ item: T) {
        do {
            try realm.write {
                realm.add(item)
                print("Realm create")
            }
        } catch {
            print(error)
        }
        print(realm.configuration.fileURL!)
    }
    
    // DELETE
    func deleteItem<T: Object>(_ item: T) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
    // DELETE ALL
    func deleteAllItem<T: Object>(ofType type: T.Type) {
        do {
            try realm.write {
                realm.delete(realm.objects(T.self))
            }
        } catch {
            print(error)
        }
    }
}

extension RealmManager {
    func loadComplaint(id: UUID) -> Complaint? {
        guard let realmComplaint = realm.object(ofType: RMComplaint.self, 
                                                forPrimaryKey: id) 
        else {
            return nil
        }
        
        return realmComplaint.asLocal()
    }
    
    func loadAllComplaints() -> [Complaint] {
        let realmComplaint = realm.objects(RMComplaint.self)
            .sorted(byKeyPath: "date", ascending: false)
            .map { $0.asLocal() }
        
        return Array(realmComplaint)
        
    }
    
    func loadRecentComplaints() -> [RecentComplaint] {
        let realmComplaint = realm.objects(RMComplaint.self)
            .sorted(byKeyPath: "date", ascending: false)
            .prefix(5)
            .map { $0.asLocalRecentComplaint() }
        
        return Array(realmComplaint)
    }
    
    func loadProfile() -> Profile? {
        let realmProfile = realm.objects(RMProfile.self).first
        let localProfile = realmProfile?.asLocal()
        
        return localProfile
    }
    
    func isProfileExists() -> Bool {
        let isProfileExists = !realm.objects(RMProfile.self).isEmpty
        return isProfileExists
    }
    
    func deleteProfile() {
        deleteAllItem(ofType: RMProfile.self)
    }
}
