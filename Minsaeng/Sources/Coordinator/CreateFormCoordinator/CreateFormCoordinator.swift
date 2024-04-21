//
//  CreateFormCoordinator.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/21.
//

import UIKit

final class CreateFormCoordinator: Coordinator {
    var type: CoordinatorType { .main }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Start: CreateForm Flow")
        let reactor = CreateFormReactor()
        let viewController = CreateFormViewController(with: reactor, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension CreateFormCoordinator: CreateFormCoordinatorInterface {
    
    
}

