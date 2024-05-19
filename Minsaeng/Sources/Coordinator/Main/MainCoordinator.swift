//
//  MainCoordinator.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/19.
//

import UIKit
import RxSwift

final class MainCoordinator: Coordinator {
    var type: CoordinatorType { .main }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var imageData: PublishSubject<Data> = .init()
    
    var disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        print("Start: Main Flow")
        let reactor = MainReactor()
        let viewController = MainViewController(coordinator: self,
                                                reactor: reactor)
        navigationController.setViewControllers([viewController], 
                                                animated: true)
        
        bind()
    }
    
    private func bind() {
        imageData
            .bind(with: self, onNext: { owner, data in
                owner.pushCreateView(data: data)
            })
            .disposed(by: disposeBag)
    }
}

extension MainCoordinator: MainCoordinatorInterface {
    func pushCameraView(option: CaptureOption) {
        let coordinator = CameraCoordinator(navigationController: navigationController,
                                            captureOption: option)
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        coordinator.start(option: option)
    }
    
    func pushCreateView(data: Data) {
        let coordinator = CreateFormCoordinator(navigationController: navigationController, 
                                                imageData: data)
        coordinator.finishDelegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushViewAllComplaints() {
        print("viewAllComplaints")
    }
    
    func pushSettingView() {
        // setting Flow의 start 화면으로 push합니다.
    }
    
}

extension MainCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("End: \(childCoordinator.type) Flow")
        removeChildCoordinator(child: childCoordinator)
    }
    
    func coordinatorDidFinishWithData(childCoordinator: Coordinator, data: Data) {
        print("End: \(childCoordinator.type) Flow")
        removeChildCoordinator(child: childCoordinator)
        
        switch childCoordinator.type {
        case .cameraRequired:
            self.imageData.onNext(data)
        default:
            break
        }
    }
}
