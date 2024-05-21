//
//  ViewAllViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/20.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class ViewAllViewController: BaseViewController {
    deinit {
        print("deinit: \(self)")
        coordinator.finish()
    }
    
    private let viewAllView = ViewAllView()
    
    private let coordinator: ViewAllCoordinatorInterface
    
    init(coordinator: ViewAllCoordinatorInterface,
         reactor: ViewAllReactor) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = viewAllView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    func setupNavigation() {
        title = "신고 내역"
        navigationItem.backBarButtonItem?.tintColor = .MSMain
    }
}

extension ViewAllViewController: View {
    func bind(reactor: ViewAllReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ViewAllReactor) {
        self.rx.methodInvoked(#selector(UIViewController.viewDidLoad))
            .map{ _ in ViewAllReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)   
        
        viewAllView.complaintsCollectionView.rx.itemSelected
            .map { ViewAllReactor.Action.pushDetailComplaint(idx: $0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ViewAllReactor) {
        reactor.pulse(\.$isPushDetailComplaint)
            .filter { $0.0 }
            .map { $0.idx }
            .bind(with: self) { owner, idx in
                owner.coordinator.pushDetailComplaint(idx: idx)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$complaints)
            .bind(to: viewAllView.complaintsCollectionView.rx.items(
                cellIdentifier: ViewAllComplaintsCell.reuseIdentifier,
                cellType: ViewAllComplaintsCell.self
            )) { index, item, cell in
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$userInfo)
            .bind(with: self) { owner, userInfo in
                owner.viewAllView.infoView.setLabelAttribute(name: userInfo.name,
                                                             count: userInfo.count)
            }
            .disposed(by: disposeBag)
    }
}

