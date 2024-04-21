//
//  CreateFormViewController.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/21.
//

import UIKit
import ReactorKit

final class CreateFormViewController: BaseViewController {
    deinit {
        print("deinit: \(self)")
    }
    
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
        collectionView.register(ViolationTypeCell.self, forCellWithReuseIdentifier: "ViolationTypeCell")
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
        violationCollectionView.delegate = self
        violationCollectionView.dataSource = self
    }
    
    override func setupUI() {
        [photoView, vehicleNumberView, violationView, detailContentView, replyOptionView].forEach {
            view.addSubview($0)
            $0.backgroundColor = .systemCyan
        }
        photoView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
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
}

extension CreateFormViewController: View {
    func bind(reactor: CreateFormReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: CreateFormReactor) {
        
    }
    
    private func bindState(reactor: CreateFormReactor) {
        
    }
}

extension CreateFormViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViolationTypeCell", for: indexPath) as? ViolationTypeCell else {
            return UICollectionViewCell()
        }
        cell.contentView.backgroundColor = .systemYellow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (view.bounds.width - 48.0 - 12) / 3, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0
    }
    
}
