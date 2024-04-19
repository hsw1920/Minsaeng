//
//  Coordinator.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/17.
//
import UIKit

protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var type: CoordinatorType { get }
    
    func start()
}

extension Coordinator {
    func addChildCoordinator(child: Coordinator) {
        childCoordinators.append(child)
    }
    
    func removeChildCoordinator(child: Coordinator) {
        childCoordinators = childCoordinators.filter { $0.type != child.type }
    }
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

enum CoordinatorType {
    case app
    case main
    case profile
}
