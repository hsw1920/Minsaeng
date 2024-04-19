//
//  AppCoordinator.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/17.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var type: CoordinatorType { .app }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        print("Start: App Flow")
        self.showProfileFlow()
    }
    
    private func showProfileFlow() {
        let coordinator = ProfileCoordinator(navigationController: navigationController)
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func showMainFlow() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("End: \(childCoordinator.type) Flow")
        removeChildCoordinator(child: childCoordinator)
        
        switch childCoordinator.type {
        case .profile:
            childCoordinators.removeAll()
            navigationController.viewControllers.removeAll()

            showMainFlow()
        default:
            break
        }
    }   
}

