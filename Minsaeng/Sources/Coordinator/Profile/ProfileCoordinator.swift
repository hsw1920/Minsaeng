//
//  ProfileCoordinator.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/17.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    var type: CoordinatorType { .profile }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Start: Profile Flow")
        let reactor = ProfileNameCreationReactor()
        let profile = Profile(name: "", phoneNumber: "")
        let viewController = ProfileNameCreationViewController(with: reactor, coordinator: self, component: profile)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension ProfileCoordinator: ProfileCoordinatorInterface {
    func pushPhoneNumberCreationView(profile: Profile) {
        let reactor = ProfilePhoneNumberCreationReactor()
        let viewController = ProfilePhoneNumberCreationViewController(with: reactor, coordinator: self, component: profile)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func pushCompleteView(profile: Profile) {
        let realmManager = RealmManager()
        realmManager.createItem(profile.asRealm())
        let reactor = ProfileCompleteReactor()
        let viewController = ProfileCompleteViewController(with: reactor, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func pushMainView() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
