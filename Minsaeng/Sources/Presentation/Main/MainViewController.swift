//
//  MainViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/19.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: BaseViewController {
    deinit {
        print("deinit: \(self)")
    }

    private let testButton: UIButton = {
        let button = UIButton()
        button.setTitle("메시지 생성", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let coordinator: MainCoordinatorInterface
    
    init(coordinator: MainCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        bind()
    }
    
    func setupNavigation() {
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(
            image: UIImage(systemName: "person.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapSettingButton)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    override func setupUI() {
        view.addSubview(testButton)
        testButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bind() {
        testButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.coordinator.pushCreateView()
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController {
    @objc
    func didTapSettingButton() {
        print("Start: Setting Flow")
    }
}
