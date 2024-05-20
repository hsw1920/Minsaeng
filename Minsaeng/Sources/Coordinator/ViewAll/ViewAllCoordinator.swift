//
//  ViewAllCoordinator.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/20.
//

import UIKit

final class ViewAllCoordinator: Coordinator {
    deinit {
        print("deinit: \(self)")
    }
    var type: CoordinatorType { .viewAll }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Start: ViewAll Flow")
        let reactor = ViewAllReactor()
        let viewController = ViewAllViewController(coordinator: self,
                                                reactor: reactor)
        navigationController.pushViewController(viewController,
                                                animated: true)
    }
    
}

extension ViewAllCoordinator: ViewAllCoordinatorInterface {
    func finish() {
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

