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

    private let testLabel: UILabel = {
        let label = UILabel()
        label.text = "Main 화면"
        return label
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
        view.addSubview(testLabel)
        testLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension MainViewController {
    @objc
    func didTapSettingButton() {
        print("Start: Setting Flow")
    }
}
