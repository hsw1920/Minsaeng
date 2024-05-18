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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "홈"
        label.textColor = .MSBlack
        label.font = .systemFont(ofSize: 26, weight: .medium)
        return label
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "person.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .MSBlack
        return button
    }()
    
    private let complaintButton: UIButton = {
        let button = UIButton()
        button.setTitle("메시지 생성", for: .normal)
        button.setTitleColor(.MSBlack, for: .normal)
        return button
    }()
    
    private let coordinator: MainCoordinatorInterface
    
    init(coordinator: MainCoordinatorInterface,
         reactor: MainReactor) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.titleBarItem.customView = titleLabel
        self.profileBarItem.customView = profileButton
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func setupUI() {
        view.addSubview(complaintButton)
        
        complaintButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension MainViewController: View {
    func bind(reactor: MainReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: MainReactor) {
        complaintButton.rx.tap
            .map { MainReactor.Action.pushComplaint }
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
    }
}
