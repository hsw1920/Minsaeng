//
//  ProfileCoordinatorInterface.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/17.
//

import Foundation

protocol ProfileCoordinatorInterface {
    func pushPhoneNumberCreationView(profile: Profile)
    func pushCompleteView(profile: Profile)
    func pushMainView()
}
