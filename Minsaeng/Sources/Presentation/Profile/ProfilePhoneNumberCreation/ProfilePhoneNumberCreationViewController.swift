//
//  ProfilePhoneNumberCreationViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/15.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

final class ProfilePhoneNumberCreationViewController: BaseViewController {
    deinit {
        print("deinit: \(self)")
    }
    private let coordinator: ProfileCoordinatorInterface
    private var component: Profile
    
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
    
    private let stepImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ProfileStep2"))
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "휴대전화를 입력해주세요"
        label.textColor = .MSBlack
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.alpha = 0.0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .MSBlack
        textField.font = .systemFont(ofSize: 24)
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.keyboardType = .numberPad
        textField.placeholder = "휴대전화를 입력해주세요"
        return textField
    }()
    
    private let underLine: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.MSBorderGray.cgColor
        return view
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.MSWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setBackgroundColor(.MSMain, for: .normal)
        button.setBackgroundColor(.MSLightMain, for: .highlighted)
        return button
    }()
    
    // MARK: Init
    init(with reactor: ProfilePhoneNumberCreationReactor, 
         coordinator: ProfileCoordinatorInterface,
         component: Profile) {
        self.coordinator = coordinator
        self.component = component
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        phoneNumberTextField.becomeFirstResponder()
    }
    
    override func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [stepImage, titleLabel, phoneNumberTextField, nextButton, descriptionLabel].forEach {
            contentView.addSubview($0)
        }
        
        phoneNumberTextField.addSubview(underLine)
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
        
        stepImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(35)
            $0.height.equalTo(15)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stepImage.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(phoneNumberTextField.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(32)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(62)
        }
    }
    
    private func setupNavigation() {
        title = "프로필 설정"
        navigationItem.setHidesBackButton(true, animated: true)
    }
}

extension ProfilePhoneNumberCreationViewController: View {
    func bind(reactor: ProfilePhoneNumberCreationReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ProfilePhoneNumberCreationReactor) {
        phoneNumberTextField.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { ProfilePhoneNumberCreationReactor.Action.textFieldValueChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .map { ProfilePhoneNumberCreationReactor.Action.buttonTapped(self.phoneNumberTextField.text ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ProfilePhoneNumberCreationReactor) {
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
                guard let phoneNumber = owner.phoneNumberTextField.text else { return }
                owner.component.phoneNumber = phoneNumber
                owner.coordinator.pushCompleteView(profile: owner.component)
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

extension ProfilePhoneNumberCreationViewController {
    private func animatingWithState(with state: TextFieldState) {
        self.view.layoutIfNeeded()
        switch state {
        case .empty:
            UIView.animate(withDuration: 0.3) {
                self.nextButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            }
            self.titleLabel.alpha = 0
            self.underLine.layer.borderColor = UIColor.MSBorderGray.cgColor
            self.descriptionLabel.text = "본인의 휴대전화 번호를 입력해주세요. (번호만 입력)"
            self.descriptionLabel.textColor = .MSDarkGray
            self.nextButton.setBackgroundColor(.clear, for: .normal)
        case .none:
            UIView.transition(with: self.view, duration: 0.3) {
                self.titleLabel.alpha = 1
                self.underLine.layer.borderColor = UIColor.MSMain.cgColor
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.3) {
                self.nextButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            }
            self.descriptionLabel.text = "본인의 휴대전화 번호를 입력해주세요. (번호만 입력)"
            self.descriptionLabel.textColor = .MSDarkGray
        case .success:
            UIView.transition(with: self.view, duration: 0.3) {
                self.titleLabel.alpha = 1
                self.underLine.layer.borderColor = UIColor.MSMain.cgColor
                self.nextButton.setBackgroundColor(.MSMain, for: .normal)
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.3) {
                self.nextButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(62)
                }
                self.view.layoutIfNeeded()
            }
            
            self.descriptionLabel.text = "본인의 휴대전화 번호를 입력해주세요. (번호만 입력)"
            self.descriptionLabel.textColor = .MSDarkGray
        case .warning:
            UIView.transition(with: self.view, duration: 0.3) {
                self.titleLabel.alpha = 1
                self.underLine.layer.borderColor = UIColor.MSWarning.cgColor
                self.nextButton.setBackgroundColor(.MSLightMain, for: .normal)
                self.view.layoutIfNeeded()
            }
            
            self.descriptionLabel.text = "올바르지 않은 휴대전화 번호 형식입니다."
            self.descriptionLabel.textColor = .MSWarning
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
