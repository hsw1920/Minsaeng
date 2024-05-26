//
//  CreateFormCoordinator.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/21.
//

import UIKit
import RxSwift
import MessageUI
import ReactorKit

final class CreateFormCoordinator: Coordinator {
    var disposeBag = DisposeBag()
    
    var type: CoordinatorType { .createForm }
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var imageData: Data
    
    init(navigationController: UINavigationController, imageData: Data) {
        self.navigationController = navigationController
        self.imageData = imageData
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    func start() {
        let realmManager = RealmManager()
        print("Start: CreateForm Flow")
        // TODO: CoreML
        let violation: Violation = .etc
        let vehicleNumber: String = "01가1234"
        
        // TODO: Profile LocalDB
        guard let profile = realmManager.loadProfile() else { return }
        
        let component = CreateFormComponentImpl(vehicleNumber: vehicleNumber,
                                                violationType: violation,
                                                detailContent: violation.description,
                                                profile: profile,
                                                isReceived: true,
                                                requiredImageData: imageData, 
                                                optionalImageData: nil)
        let reactor = CreateFormReactor(component: component)
        let viewController = CreateFormViewController(with: reactor, coordinator: self)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController.pushViewController(viewController, animated: true)
        
        bind(with: viewController,
             reactor: reactor)
    }
    
    private func bind(with viewController: CreateFormViewController,
                      reactor: CreateFormReactor) {
        reactor.readyToConfirm
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self, onNext: { owner, component in
                owner.showSendMessage(viewController: viewController,
                                      component: component)
            })
            .disposed(by: disposeBag)
    }
    
    private func showSendMessage(viewController: CreateFormViewController,
                                 component: CreateFormComponentImpl) {
        guard MFMessageComposeViewController.canSendText() else {
            print("SMS services are not available")
            return
        }
        let dateFormatter = MSDateFormatter()
        let formattedDate = dateFormatter.getTimeAll(date: component.date)
        let messageViewController = MFMessageComposeViewController()
        
        messageViewController.messageComposeDelegate = viewController
        messageViewController.recipients = ["02120"]
        messageViewController.body = """
        위반 차량 번호: \(component.vehicleNumber)
        위반 유형: \(component.violationType.toString)
        위치: <component.location>
        상세 내용: \(component.detailContent)
        일시: \(formattedDate)
        신고자 이름: \(component.profile.name)
        신고자 번호: \(component.profile.phoneNumber)
        회신 동의 여부: \(component.isReceived ? "예" : "아니오")
        """
        
        let requiredImageData = component.requiredImageData
        messageViewController.addAttachmentData(requiredImageData, typeIdentifier: "required.png", filename: "requiredImage.png")
        
        if let optionalImage = component.optionalImageData {
            messageViewController.addAttachmentData(optionalImage, typeIdentifier: "optional.png", filename: "optionalImage.png")
        }

        viewController.present(messageViewController, animated: true)
    }
}

extension CreateFormCoordinator: CreateFormCoordinatorInterface {
    func presentCamera(_ viewController: CreateFormViewController, option: CaptureOption) {
        let coordinator = CameraCoordinator(navigationController: navigationController, 
                                            captureOption: option)
        coordinator.finishDelegate = self
        coordinator.start(option: option)
    }
    
    func finishCreateForm(_ viewController: CreateFormViewController) {
        // MARK: 왜 강제로 해제해야할까?
        disposeBag = DisposeBag()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        navigationController.popViewController(animated: true)
    }
}

extension CreateFormCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        print("End: \(childCoordinator.type) Flow")
        removeChildCoordinator(child: childCoordinator)
    }
    
    func coordinatorDidFinishWithData(childCoordinator: Coordinator, data: Data) {
        print("End: \(childCoordinator.type) Flow")
        removeChildCoordinator(child: childCoordinator)
        
        switch childCoordinator.type {
        case .cameraOptional:
            if let presentingVC = navigationController.viewControllers.first(where: { $0 is CreateFormViewController }) as? CreateFormViewController {
                presentingVC.captureImage.accept(data)
            }
        default:
            break
        }
    }
}

