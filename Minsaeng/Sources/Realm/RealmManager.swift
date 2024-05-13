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
    func loadProfile() -> Profile? {
        do {
            let realm = try Realm()
            let realmProfile = realm.objects(RMProfile.self).first
            let localProfile = realmProfile?.asLocal()
            return localProfile
        } catch {
            print("loadProfile From Realm Error")
            return nil
        }
    }
    
    func isProfileExists() -> Bool {
        do {
            let realm = try Realm()
            let isProfileExists = !realm.objects(RMProfile.self).isEmpty
            return isProfileExists
        } catch {
            print("isProfileExists From Realm Error")
            return false
        }
    }
    
    func deleteProfile() {
        deleteAllItem(ofType: RMProfile.self)
    }
}
