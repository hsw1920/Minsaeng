//
//  CreateFormViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/21.
//

import UIKit
import RxCocoa
import ReactorKit

final class CreateFormViewController: BaseViewController {
    deinit {
        print("deinit: \(self)")
    }
    
    private let coordinator: CreateFormCoordinator
    private let createFormView = CreateFormView()
    
    // MARK: Init
    init(with reactor: CreateFormReactor, coordinator: CreateFormCoordinator) {
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
}

extension CreateFormViewController: View {
    func bind(reactor: CreateFormReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: CreateFormReactor) {
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
            .map(\.placeholder)
            .bind(to: createFormView.detailContentTextView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isSelectedReplyButton)
            .distinctUntilChanged()
            .map(parseReplyButtonImage)
            .bind(to: createFormView.replyOptionButton.rx.image())
            .disposed(by: disposeBag)
    }
}

extension CreateFormViewController {
    private func parseReplyButtonImage(with isSelected: Bool) -> UIImage? {
        return isSelected ?
        UIImage(systemName: "checkmark.square.fill")
        :UIImage(systemName: "square")
    }
}
