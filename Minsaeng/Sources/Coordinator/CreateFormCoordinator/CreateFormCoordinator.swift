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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("deinit: \(self)")
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
        viewController.modalPresentationStyle = .overFullScreen
        
        navigationController.present(viewController, animated: true)
        
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
        
        let messageViewController = MFMessageComposeViewController()
        
        messageViewController.messageComposeDelegate = viewController
        messageViewController.recipients = ["1234567890"]
        messageViewController.body = """
        위반 차량 번호: \(component.vehicleNumber)
        위반 유형: \(component.violationType)
        상세 내용: \(component.detailContent)
        일시: \(component.date)
        신고자 이름: \(component.name)
        신고자 번호: \(component.phoneNumber)
        """
        
        let image = UIImage(systemName: "sun.max")
        
        if let imageData = image?.pngData() {
            messageViewController.addAttachmentData(imageData, typeIdentifier: "public.png", filename: "image.png")
        }
        
        viewController.present(messageViewController, animated: true)
    }
}

extension CreateFormCoordinator: CreateFormCoordinatorInterface {
    func finishCreateForm(_ viewController: CreateFormViewController) {
        // MARK: 왜 강제로 해제해야할까?
        disposeBag = DisposeBag()
        viewController.dismiss(animated: true)
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

