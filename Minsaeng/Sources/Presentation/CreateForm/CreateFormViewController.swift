//
//  CreateFormViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/21.
//

import UIKit
import RxCocoa
import ReactorKit
import MessageUI

final class CreateFormViewController: BaseViewController {
    deinit {
        print("deinit: \(self)")
    }
    
    private let coordinator: CreateFormCoordinatorInterface
    private let createFormView = CreateFormView()
    
    var captureImage = PublishRelay<Data?>()
    
    // MARK: Init
    init(with reactor: CreateFormReactor, coordinator: CreateFormCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = createFormView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator.finishCreateForm(self)
    }
    
    private func setupNavigation() {
        title = "민원 문자 생성"
    }
}

extension CreateFormViewController: View {
    func bind(reactor: CreateFormReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
        
        createFormView.shootPhotoButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.coordinator.presentCamera(owner, option: .optional)
            }
            .disposed(by: disposeBag)
        
        createFormView.removePhotoButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.createFormView.removeOptionalPhoto()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAction(reactor: CreateFormReactor) {
        self.rx.methodInvoked(#selector(UIViewController.viewDidLoad))
            .map{ _ in CreateFormReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        createFormView.violationCollectionView.rx.itemSelected
            .map { CreateFormReactor.Action.violationButtonTapped($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        createFormView.replyOptionButton.rx.tap
            .map { CreateFormReactor.Action.replyButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        createFormView.confirmButton.rx.tap
            .map { CreateFormReactor.Action.confirmButtonTapped }
            .do(onNext: { [weak self] _ in
                self?.view.endEditing(true)
                self?.startActivityIndicator()
            })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        createFormView.detailContentTextView.rx.text.orEmpty
            .map { CreateFormReactor.Action.editDetailContent($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        captureImage.asObservable()
            .map { CreateFormReactor.Action.shootCamera($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        createFormView.removePhotoButton.rx.tap
            .map { CreateFormReactor.Action.removeOptionalPhoto }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: CreateFormReactor) {
        reactor.state
            .map(\.violations)
            .bind(to: createFormView.violationCollectionView.rx.items(
                cellIdentifier: ViolationTypeCell.reuseIdentifier,
                cellType: ViolationTypeCell.self
            )) { index, item, cell in
                cell.configure(type: item)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.vehicleNumber)
            .bind(to: createFormView.vehicleNumberTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.detailContent)
            .distinctUntilChanged()
            .bind(to: createFormView.detailContentTextView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isSelectedReplyButton)
            .distinctUntilChanged()
//            .map(parseReplyButtonImage)
            // MARK: 그냥 map으로 하면 강한참조 걸린다.
            .map { [weak self] isSelected in
                self?.parseReplyButtonImage(with: isSelected)
            }
            .bind(to: createFormView.replyOptionButton.rx.image())
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.captureImageData)
            .bind(with: self) { owner, data in
                owner.createFormView.addOptionalPhoto(with: data)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.requiredImageData)
            .bind(with: self) { owner, data in
                owner.createFormView.addRequiredPhoto(with: data)
            }
            .disposed(by: disposeBag)
    }
}

extension CreateFormViewController {
    private func parseReplyButtonImage(with isSelected: Bool) -> UIImage? {
        return isSelected ?
        UIImage(systemName: "checkmark.square.fill")
        :UIImage(systemName: "square")
    }
    
    func startActivityIndicator() {
        createFormView.confirmButton.setTitle("", for: .normal)
        createFormView.activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        createFormView.confirmButton.setTitle("작성 완료", for: .normal)
        createFormView.activityIndicator.stopAnimating()
    }
}

extension CreateFormViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        self.stopActivityIndicator()
        switch result {
        case .cancelled:
            dismiss(animated: true)
        case .sent:
            dismiss(animated: true) {
                self.coordinator.finishCreateForm(self)
            }
        case .failed:
            print(">>> Failed")
            dismiss(animated: true)
        @unknown default:
            print(">>> Unknown Error")
            dismiss(animated: true)
        }
    }
}
