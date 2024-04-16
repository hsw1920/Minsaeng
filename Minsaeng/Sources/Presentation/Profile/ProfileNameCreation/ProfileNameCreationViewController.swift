//
//  ProfileNameCreationViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/15.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class ProfileNameCreationViewController: BaseViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delaysContentTouches = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이름을 입력해주세요"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.alpha = 0.0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "올바르지 않은 이름 형식입니다."
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemRed
        label.alpha = 0.0
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 24)
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.placeholder = "이름을 입력해주세요"
        return textField
    }()
    
    private let underLine: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    // MARK: Init
    init(with reactor: ProfileNameCreationReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
    
    override func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [titleLabel, nameTextField, nextButton, descriptionLabel].forEach {
            contentView.addSubview($0)
        }
        
        nameTextField.addSubview(underLine)
        underLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(62)
            $0.leading.equalToSuperview().inset(24)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(32)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(62)
        }
    }
}

extension ProfileNameCreationViewController: View {
    func bind(reactor: ProfileNameCreationReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ProfileNameCreationReactor) {
        nameTextField.rx.text.orEmpty
            .map { ProfileNameCreationReactor.Action.textFieldValueChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .map { ProfileNameCreationReactor.Action.buttonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ProfileNameCreationReactor) {
        reactor.state
            .map(\.isActive)
            .distinctUntilChanged()
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isPresent)
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
                let reactor = ProfilePhoneNumberCreationReactor()
                let nextViewController = ProfilePhoneNumberCreationViewController(with: reactor)
                owner.navigationController?.pushViewController(nextViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.textFieldState)
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, state in
                owner.animatingWithState(with: state)
            })
            .disposed(by: disposeBag)
    }
}

extension ProfileNameCreationViewController {
    private func animatingWithState(with state: TextFieldState) {
        self.view.layoutIfNeeded()
        switch state {
            
        case .empty:
            self.titleLabel.alpha = 0
            self.underLine.layer.borderColor = UIColor.lightGray.cgColor
            self.descriptionLabel.alpha = 0.0
            self.nextButton.alpha = 0.0
            
            UIView.animate(withDuration: 0.3) {
                self.nextButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            }
        case .none:
            UIView.transition(with: self.view, duration: 0.3) {
                self.titleLabel.alpha = 1
                self.underLine.layer.borderColor = UIColor.systemBlue.cgColor
                self.descriptionLabel.alpha = 0.0
                self.view.layoutIfNeeded()
            }
            
            UIView.animate(withDuration: 0.3) {
                self.nextButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            }
        case .success:
            UIView.transition(with: self.view, duration: 0.3) {
                self.titleLabel.alpha = 1
                self.underLine.layer.borderColor = UIColor.systemBlue.cgColor
                self.descriptionLabel.alpha = 0.0
                self.nextButton.alpha = 1.0
                self.view.layoutIfNeeded()
            }
            
            UIView.animate(withDuration: 0.3) {
                self.nextButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(62)
                }
                self.view.layoutIfNeeded()
            }
        case .warning:
            UIView.transition(with: self.view, duration: 0.3) {
                self.titleLabel.alpha = 1
                self.underLine.layer.borderColor = UIColor.systemRed.cgColor
                self.descriptionLabel.alpha = 1.0
                self.nextButton.alpha = 0.5
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func setKeyboardObserver() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        .compactMap { $0.userInfo }
        .compactMap { $0[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
        .bind(with: self, onNext: { owner, element in
            let keyboardHeight = element.cgRectValue.height - owner.view.safeAreaInsets.bottom
            owner.scrollView.snp.updateConstraints {
                $0.bottom.equalTo(owner.view.safeAreaLayoutGuide).inset(keyboardHeight - 62)
            }
            owner.view.layoutIfNeeded()
        })
        .disposed(by: disposeBag)
    }
}
