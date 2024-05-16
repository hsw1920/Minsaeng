//
//  CameraCoordinator.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/16.
//

import UIKit

final class CameraCoordinator: Coordinator {
    deinit {
        print("deinit: \(self)")
    }
    var type: CoordinatorType {
        switch captureOption {
        case .required:
            return .cameraRequired
        case .optional:
            return .cameraOptional
        }
    }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let captureOption: CaptureOption
    
    init(navigationController: UINavigationController,
         captureOption: CaptureOption) {
        self.navigationController = navigationController
        self.captureOption = captureOption
    }
    
    func start() {}
    
    func start(option: CaptureOption) {
        print("Start: Camera Flow")
        let viewController = CameraViewController(coordinator: self,
                                                  captureOption: option)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: true)
    }
}

extension CameraCoordinator: CameraCoordinatorInterface {
    func cancelCamera(_ viewController: CameraViewController) {
        print("카메라 취소")
        viewController.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        }
    }
    
    func finishCamera(_ viewController: CameraViewController, option: CaptureOption, imageData: Data) {
        print("카메라 촬영")
        viewController.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            finishDelegate?.coordinatorDidFinishWithData(childCoordinator: self, data: imageData)
        }
    }
}
