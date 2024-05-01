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
    
    var type: CoordinatorType { .createForm }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Start: CreateForm Flow")
        // TODO: CoreML
        let violation: Violation = .etc
        let vehicleNumber: String = "<#차량번호>"
        
        // TODO: Profile LocalDB
        let name: String = "이름"
        let phoneNumber: String = "휴대전화 번호"
        
        let component = CreateFormComponentImpl(vehicleNumber: vehicleNumber,
                                                violationType: violation,
                                                detailContent: violation.description,
                                                name: name,
                                                phoneNumber: phoneNumber)
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

