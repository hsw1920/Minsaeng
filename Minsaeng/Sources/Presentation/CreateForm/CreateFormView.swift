//
//  CreateFormView.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/23.
//

import UIKit
import RxSwift

final class CreateFormView: UIView {
    var disposeBag = DisposeBag()
    
    let scrollView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let photoView: UIView = .init()
    
    let shootPhotoButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.backgroundColor = .systemGreen
        return button
    }()
    
    private let requiredPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let optionalPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    let removePhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.backgroundColor = .systemRed
        return button
    }()
    
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
    
    let vehicleNumberTextField: UITextField = {
        let textField = UITextField()
        textField.isEnabled = false
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
    
    let violationCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ViolationTypeCell.self, forCellWithReuseIdentifier: ViolationTypeCell.reuseIdentifier)
        return collectionView
    }()
    
    private let detailContentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "상세내용"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let detailContentTextView: UITextView = {
        let textView = UITextView()
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.layer.cornerRadius = 12
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.layer.borderWidth = 1
        return textView
    }()

    let replyOptionButton: UIButton = {
        let button = UIButton()
        button.setImage(.strokedCheckmark, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "(선택) 민원 접수 후 회신에 동의합니다.",
                                                     attributes: [.font : UIFont.systemFont(ofSize: 16, weight: .bold)]),
                                  for: .normal)
        return button
    }()

    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("작성 완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        activityIndicator.style = .medium
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setKeyboardObserver()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
        setKeyboardObserver()
    }
    
    override func layoutSubviews() {
        setCollectionView()
    }
    
    private func setupUI() {
        self.addSubview(scrollView)
        self.addSubview(confirmButton)
        confirmButton.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
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
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        [photoView, vehicleNumberView, violationView, detailContentView, replyOptionView].forEach {
            contentView.addSubview($0)
            
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 1
        }
        
        photoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(112)
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
        [replyOptionButton].forEach { replyOptionView.addSubview($0) }
        
        photoTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        photoStackView.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
            $0.height.equalTo(80)
        }

        [shootPhotoButton, requiredPhoto].forEach {
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(80)
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
        
        replyOptionButton.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
        }
    }
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6.0
        layout.minimumInteritemSpacing = 6.0
        layout.itemSize = CGSize(width: (self.bounds.width - 48.0 - 12) / 3, height: 48)
        violationCollectionView.collectionViewLayout = layout
    }
    
    private func setOptionalPhotoUI() {
        photoStackView.addArrangedSubview(optionalPhoto)
        photoView.addSubview(removePhotoButton)
        
        optionalPhoto.snp.makeConstraints {
            $0.width.height.equalTo(80)
        }
        
        removePhotoButton.snp.makeConstraints {
            $0.top.trailing.equalTo(optionalPhoto).inset(-8)
            $0.width.height.equalTo(24)
        }
    }
    
    func addOptionalPhoto(with data: Data?) {
        guard let data,
        let image = UIImage(data: data) else { return }
        optionalPhoto.image = image
        
        setOptionalPhotoUI()
    }
    
    func removeOptionalPhoto() {
        optionalPhoto.snp.removeConstraints()
        removePhotoButton.snp.removeConstraints()
        optionalPhoto.removeFromSuperview()
        removePhotoButton.removeFromSuperview()
    }
}

extension CreateFormView {
    private func setKeyboardObserver() {
        let textViewBeginEditingObservable = detailContentTextView.rx.didBeginEditing.asObservable()
        let keyboardWillShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).asObservable()
        
        Observable.zip(textViewBeginEditingObservable, keyboardWillShowObservable)
            .compactMap { $1.userInfo }
            .compactMap { $0[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, element in
                let keyboardHeight = element.cgRectValue.height - owner.safeAreaInsets.bottom
                owner.confirmButton.snp.updateConstraints {
                    $0.bottom.equalTo(owner.safeAreaLayoutGuide).inset(keyboardHeight)
                }
                
                var contentInset: UIEdgeInsets = owner.scrollView.contentInset
                contentInset.bottom = element.cgRectValue.height - 62
                owner.scrollView.contentInset = contentInset
                owner.scrollView.setContentOffset(CGPoint(x: 0, y: keyboardHeight),
                                                  animated: true)
                
                owner.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, element in
                owner.confirmButton.snp.updateConstraints {
                    $0.bottom.equalTo(owner.safeAreaLayoutGuide.snp.bottom)
                }
                
                let contentInset: UIEdgeInsets = UIEdgeInsets.zero
                owner.scrollView.contentInset = contentInset
                owner.scrollView.setContentOffset(.zero,
                                                  animated: true)
                
                owner.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
}
