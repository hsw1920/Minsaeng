//
//  CreateFormCoordinator.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/21.
//

import UIKit
import RxSwift

final class CreateFormCoordinator: Coordinator {
    var disposeBag = DisposeBag()
    
    var type: CoordinatorType { .main }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Start: CreateForm Flow")
        let component: Violation = .crosswalk
        let reactor = CreateFormReactor(component: component)
        let viewController = CreateFormViewController(with: reactor, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
        
        reactor.readyToConfirm
            .bind(with: self, onNext: { owner, component in
                // MessageFlow 시작
                print("Start: CreateMessage Flow")
                print(component)
            })
            .disposed(by: disposeBag)
    }
    
    
}

extension CreateFormCoordinator: CreateFormCoordinatorInterface {
    
    
}

