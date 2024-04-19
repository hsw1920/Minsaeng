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
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MainCoordinator: MainCoordinatorInterface {
    func pushCreateView() {
        // create Flow의 start 화면으로 push합니다.
    }
    
    func pushSettingView() {
        // setting Flow의 start 화면으로 push합니다.
    }
    
}
