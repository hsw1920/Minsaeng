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
    private let scrollView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let photoView: UIView = .init()
    private let vehicleNumberView: UIView = .init()
    private let violationView: UIView = .init()
    private let detailContentView: UIView = .init()
    private let replyOptionView: UIView = .init()
    
    private let photoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "사진첨부"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let photoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let vehicleNumberTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "차량번호"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let vehicleNumberTextField: UITextField = {
        let textField = UITextField()
        textField.isEnabled = false
        textField.backgroundColor = .systemGreen
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private let violationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "위반유형"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let violationCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ViolationTypeCell.self, forCellWithReuseIdentifier: ViolationTypeCell.reuseIdentifier)
        collectionView.backgroundColor = .systemGreen
        return collectionView
    }()
    
    private let detailContentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "상세내용"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let detailContentTextView: UITextView = {
        let textView = UITextView()
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.backgroundColor = .systemGreen
        textView.layer.cornerRadius = 12
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.layer.borderWidth = 1
        return textView
    }()
    
    private let replyOptionLabel: UILabel = {
        let label = UILabel()
        label.text = "(선택) 민원 접수 후 회신에 동의합니다."
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("작성 완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    private let coordinator: CreateFormCoordinator
    
    // MARK: Init
    init(with reactor: CreateFormReactor, coordinator: CreateFormCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        setKeyboardObserver()
    }
    
    override func setupUI() {
        view.addSubview(scrollView)
        view.addSubview(confirmButton)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        [photoView, vehicleNumberView, violationView, detailContentView, replyOptionView].forEach {
            contentView.addSubview($0)
            $0.backgroundColor = .systemCyan
        }
        photoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(92)
        }
        vehicleNumberView.snp.makeConstraints {
            $0.top.equalTo(photoView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(72)
        }
        violationView.snp.makeConstraints {
            $0.top.equalTo(vehicleNumberView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(188)
        }
        detailContentView.snp.makeConstraints {
            $0.top.equalTo(violationView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(132)
        }
        replyOptionView.snp.makeConstraints {
            $0.top.equalTo(detailContentView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(24)
        }
        
        [photoTitleLabel, photoStackView].forEach { photoView.addSubview($0) }
        [vehicleNumberTitleLabel, vehicleNumberTextField].forEach { vehicleNumberView.addSubview($0) }
        [violationTitleLabel, violationCollectionView].forEach { violationView.addSubview($0) }
        [detailContentTitleLabel, detailContentTextView].forEach { detailContentView.addSubview($0) }
        [replyOptionLabel].forEach { replyOptionView.addSubview($0) }
        
        photoTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        photoStackView.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
            $0.height.equalTo(60)
        }
        let view1 = UIView()
        view1.backgroundColor = .systemGreen
        let view2 = UIView()
        view2.backgroundColor = .systemGreen
        let view3 = UIView()
        view3.backgroundColor = .systemGreen
        [view1, view2, view3].forEach {
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(60)
            }
            photoStackView.addArrangedSubview($0)
        }
        
        vehicleNumberTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        vehicleNumberTextField.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        violationTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }

        violationCollectionView.snp.makeConstraints {
            $0.top.equalTo(violationTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        detailContentTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        detailContentTextView.snp.makeConstraints {
            $0.top.equalTo(detailContentTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        replyOptionLabel.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
        }
    }
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6.0
        layout.minimumInteritemSpacing = 6.0
        layout.itemSize = CGSize(width: (view.bounds.width - 48.0 - 12) / 3, height: 48)
        violationCollectionView.collectionViewLayout = layout
    }
}

extension CreateFormViewController: View {
    func bind(reactor: CreateFormReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: CreateFormReactor) {
        violationCollectionView.rx.itemSelected
            .map { CreateFormReactor.Action.violationButtonTapped($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: CreateFormReactor) {
        reactor.state
            .map(\.violations)
            .observe(on: MainScheduler.instance)
            .bind(to: violationCollectionView.rx.items(
                cellIdentifier: ViolationTypeCell.reuseIdentifier,
                cellType: ViolationTypeCell.self
            )) { index, item, cell in
                cell.configure(type: item)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.placeholder)
            .observe(on: MainScheduler.instance)
            .bind(to: detailContentTextView.rx.text)
            .disposed(by: disposeBag)
    }
}

extension CreateFormViewController {
    private func setKeyboardObserver() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        .compactMap { $0.userInfo }
        .compactMap { $0[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
        .bind(with: self, onNext: { owner, element in
            let keyboardHeight = element.cgRectValue.height - owner.view.safeAreaInsets.bottom
            owner.confirmButton.snp.updateConstraints {
                $0.bottom.equalTo(owner.view.safeAreaLayoutGuide).inset(keyboardHeight)
            }
            
            var contentInset: UIEdgeInsets = owner.scrollView.contentInset
            contentInset.bottom = element.cgRectValue.height - 62
            owner.scrollView.contentInset = contentInset
            owner.scrollView.setContentOffset(CGPoint(x: 0, y: keyboardHeight),
                                              animated: true)
            
            owner.view.layoutIfNeeded()
        })
        .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
        .bind(with: self, onNext: { owner, element in
            owner.confirmButton.snp.updateConstraints {
                $0.bottom.equalTo(owner.view.safeAreaLayoutGuide.snp.bottom)
            }
            
            let contentInset: UIEdgeInsets = UIEdgeInsets.zero
            owner.scrollView.contentInset = contentInset
            owner.scrollView.setContentOffset(.zero,
                                              animated: true)
            
            owner.view.layoutIfNeeded()
        })
        .disposed(by: disposeBag)
    }
}
