//
//  MainViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/19.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class MainViewController: BaseViewController {
    deinit {
        print("deinit: \(self)")
    }

    private let backBarItem: UIBarButtonItem = .init(title: "")
    private let titleBarItem: UIBarButtonItem = .init()
    private let profileBarItem: UIBarButtonItem = .init()
    private let mainView = MainView()
    
    private let coordinator: MainCoordinatorInterface
    
    init(coordinator: MainCoordinatorInterface,
         reactor: MainReactor) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.titleBarItem.customView = mainView.titleLabel
        self.profileBarItem.customView = mainView.profileButton
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationItem.backBarButtonItem = backBarItem
        navigationItem.leftBarButtonItem = titleBarItem
        navigationItem.rightBarButtonItem = profileBarItem
        navigationItem.backBarButtonItem?.tintColor = .MSMain
        navigationItem.rightBarButtonItem?.tintColor = .MSBlack
    }
}

extension MainViewController: View {
    func bind(reactor: MainReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: MainReactor) {
        self.rx.methodInvoked(#selector(UIViewController.viewDidLoad))
            .map{ _ in MainReactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.complaintButton.rx.tap
            .map { MainReactor.Action.pushComplaint }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.viewAllButton.rx.tap
            .map { MainReactor.Action.pushViewAllComplaints }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: MainReactor) {
        reactor.state
            .map(\.isPushComplaint)
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.coordinator.pushCameraView(option: .required)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isPushViewAllComplaints)
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.coordinator.pushViewAllComplaints()
            })
            .disposed(by: disposeBag)

        reactor.state.map(\.complaints.count)
            .bind(onNext: { [weak self] count in
                guard let self else { return }
                mainView.recentComplaintCountLabel.text = String(count)
                
                if count == 0 {
                    let backgroundView = EmptyComplaintBackgroundView()
                    mainView.recentComplaintCollectionView.backgroundView = backgroundView
                } else {
                    mainView.recentComplaintCollectionView.backgroundView = nil
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.complaints)
            .bind(to: mainView.recentComplaintCollectionView.rx.items(
                cellIdentifier: RecentComplaintCell.reuseIdentifier,
                cellType: RecentComplaintCell.self
            )) { index, item, cell in
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
    }
}
