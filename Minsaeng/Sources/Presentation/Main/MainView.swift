//
//  MainView.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/18.
//

import UIKit

final class MainView: UIView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delaysContentTouches = false
        return scrollView
    }()
    
    private let contentView: UIView = .init()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "홈"
        label.textColor = .MSBlack
        label.font = .systemFont(ofSize: 26, weight: .medium)
        return label
    }()
    
    let profileButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "person.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .MSBlack
        return button
    }()
    
    private let complaintView: UIView = {
        let view = UIView()
        view.backgroundColor = .MSBackgroundGray
        view.layer.cornerRadius = 12
        return view
    }()
    private let pinIcon: UILabel = {
        let label = UILabel()
        label.text = "📌"
        label.font = .systemFont(ofSize: 28)
        return label
    }()
    private let complaintDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "불법 주정차된 차량을\n촬영하여 신고할 수 있어요"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .MSBlack
        return label
    }()
    
    let complaintButton: UIButton = {
        let button = UIButton()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 35)
        let image = UIImage(systemName: "camera.circle.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        
        button.setTitle("신고하기", for: .normal)
        button.setTitleColor(.MSWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        button.setBackgroundColor(.MSMain, for: .normal)
        button.setBackgroundColor(.MSLightMain, for: .highlighted)
        
        button.tintColor = .MSWhite
        
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()
    
    let tipButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("🚨 신고 요령이 궁금해요", for: .normal)
        button.setTitleColor(.MSDarkGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        button.setBackgroundColor(.MSBackgroundGray, for: .normal)
        button.setBackgroundColor(.MSGray, for: .highlighted)
        
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .MSBackgroundGray
        return view
    }()
    
    private let recentComplaintSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 신고 내역"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .MSBlack
        return label
    }()
    
    let recentComplaintCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .MSBlack
        return label
    }()
    
    let viewAllButton: UIButton = .init()
    
    private let viewAllLabel: UILabel = {
        let label = UILabel()
        label.text = "더 보기"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .MSBlack
        return label
    }()
    
    private let viewAllIcon: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .MSBlack
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let recentComplaintCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(RecentComplaintCell.self,
                                forCellWithReuseIdentifier: RecentComplaintCell.reuseIdentifier)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        setCollectionView()
    }
    
    private func setupUI() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [complaintView, 
         tipButton,
         divider, 
         recentComplaintSubTitleLabel, recentComplaintCountLabel, viewAllButton,
         recentComplaintCollectionView].forEach {
            contentView.addSubview($0)
        }

        [pinIcon, complaintDescriptionLabel, complaintButton].forEach { complaintView.addSubview($0) }
        
        complaintView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(21)
            $0.height.equalTo(200)
        }
        
        pinIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(32)
        }
        
        complaintDescriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(pinIcon.snp.trailing).offset(12)
            $0.top.equalTo(pinIcon)
        }
        
        complaintButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
            $0.height.equalTo(62)
        }
        
        tipButton.snp.makeConstraints {
            $0.top.equalTo(complaintView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(62)
        }
        
        divider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(tipButton.snp.bottom).offset(24)
            $0.height.equalTo(1)
        }
        
        recentComplaintSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(16)
            $0.height.equalTo(25)
            $0.leading.equalToSuperview().inset(28)
        }
        
        recentComplaintCountLabel.snp.makeConstraints {
            $0.leading.equalTo(recentComplaintSubTitleLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(recentComplaintSubTitleLabel)
            $0.height.equalTo(25)
        }
        
        viewAllButton.snp.makeConstraints {
            $0.centerY.equalTo(recentComplaintSubTitleLabel)
            $0.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(25)
        }
        
        [viewAllLabel, viewAllIcon].forEach { viewAllButton.addSubview($0) }
        viewAllLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        viewAllIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(viewAllLabel.snp.trailing).offset(4)
            $0.trailing.equalToSuperview()
        }
        
        recentComplaintCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentComplaintSubTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.greaterThanOrEqualTo(12)
            $0.height.equalTo(200)
        }
    }
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8.0
        layout.itemSize = CGSize(width: 124, height: 200)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        recentComplaintCollectionView.collectionViewLayout = layout
        
        // MARK: 셀의 오른쪽을 뷰 포트의 오른쪽으로 맞춤
        guard let isEmptyView = recentComplaintCollectionView.backgroundView else {
            recentComplaintCollectionView.scrollToItem(at: [0,0], at: .right, animated: false)
            return
        }
    }
}

final class EmptyComplaintBackgroundView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let emptyImageView: UIImageView = {
        let image = UIImage(named: "CommonIcon")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "불법 주정차된 차량을 신고해주세요!"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .MSDarkGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(stackView)
        [emptyImageView, descriptionLabel].forEach { stackView.addArrangedSubview($0) }
        
        emptyImageView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.width.equalTo(descriptionLabel.snp.width)
        }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
