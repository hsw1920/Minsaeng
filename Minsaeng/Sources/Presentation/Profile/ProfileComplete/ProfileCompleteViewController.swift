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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 설정이 완료되었습니다!"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let imageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    // MARK: Init
    init(with reactor: ProfileCompleteCreationReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}

extension ProfileCompleteViewController: View {
    func bind(reactor: ProfileCompleteCreationReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ProfileCompleteCreationReactor) {
        nextButton.rx.tap
            .map { ProfileCompleteCreationReactor.Action.pushButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ProfileCompleteCreationReactor) {
        reactor.state
            .map(\.isPushHome)
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
//                let reactor = ProfileCompleteCreationReactor()
//                let nextViewController = ProfileCompleteViewController(with: reactor)
//                owner.navigationController?.pushViewController(nextViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

