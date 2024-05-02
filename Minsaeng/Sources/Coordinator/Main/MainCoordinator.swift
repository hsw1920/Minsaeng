//
//  MainCoordinator.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/19.
//

import UIKit

final class MainCoordinator: Coordinator {
    var type: CoordinatorType { .main }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Start: Main Flow")
        let viewController = MainViewController(coordinator: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension MainCoordinator: MainCoordinatorInterface {
    func pushCreateView() {
        let coordinator = CreateFormCoordinator(navigationController: navigationController)
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushSettingView() {
        // setting Flow의 start 화면으로 push합니다.
    }
    
}

extension MainCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("End: \(childCoordinator.type) Flow")
        removeChildCoordinator(child: childCoordinator)
        
        switch childCoordinator.type {
        case .createForm:
            // MARK: 나중에
            break
        default:
            break
        }
    }
}
