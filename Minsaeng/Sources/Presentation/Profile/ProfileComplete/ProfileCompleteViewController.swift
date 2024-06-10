//
//  ProfileCompleteViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/15.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class ProfileCompleteViewController: BaseViewController {
    deinit {
        print("deinit: \(self)")
    }
    private let coordinator: ProfileCoordinatorInterface
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .MSBlack
        label.text = "프로필 설정이 완료되었습니다!"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ProfileComplete"))
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.MSWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setBackgroundColor(.MSMain, for: .normal)
        button.setBackgroundColor(.MSLightMain, for: .highlighted)
        return button
    }()
    
    // MARK: Init    
    init(with reactor: ProfileCompleteReactor, coordinator: ProfileCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    override func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(nextButton)

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(62)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(view.bounds.width / 390 * 280)
            $0.height.equalTo(imageView.snp.width)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(62)
        }
    }
    
    private func setupNavigation() {
        title = "프로필 설정"
        navigationItem.setHidesBackButton(true, animated: true)
    }
}

extension ProfileCompleteViewController: View {
    func bind(reactor: ProfileCompleteReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ProfileCompleteReactor) {
        nextButton.rx.tap
            .map { ProfileCompleteReactor.Action.pushButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ProfileCompleteReactor) {
        reactor.state
            .map(\.isPushHome)
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.coordinator.pushMainView()
            })
            .disposed(by: disposeBag)
    }
}

