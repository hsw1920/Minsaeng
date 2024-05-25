//
//  DetailComplaintView.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/21.
//

import UIKit

final class DetailComplaintView: UIView {
    deinit {
        print("deinit: \(self)")
    }
    
    let exitButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .MSBlack
        return button
    }()
    
    let violationTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .MSBlack
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "서울특별시 광진구 XX로 XX-X"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .MSDarkGray
        return label
    }()
    
    let imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(DetailComplaintImageCell.self,
                                forCellWithReuseIdentifier: DetailComplaintImageCell.reuseIdentifier)
        return collectionView
    }()
    
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .MSGray
        pageControl.currentPageIndicatorTintColor = .MSMain
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private let detailContent: UILabel = {
        let label = UILabel()
        label.text = "상세 내용"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .MSDarkGray
        return label
    }()
    
    private let detailContnetView: UIView = {
        let view = UIView()
        view.backgroundColor = .MSMain
        view.layer.cornerRadius = 12
        return view
    }()
    
    let detailTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 14, weight: .semibold)
        textView.textAlignment = .left
        textView.textColor = .MSWhite
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        imageCollectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setCollectionView()
    }
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        imageCollectionView.collectionViewLayout = layout
    }
    
    private func setupUI() {
        [violationTypeLabel, locationLabel, imageCollectionView, pageControl, detailContent, detailContnetView].forEach {
            addSubview($0)
        }
        
        violationTypeLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.equalToSuperview().inset(12)
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(violationTypeLabel.snp.bottom).offset(4)
            $0.leading.equalTo(violationTypeLabel)
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(12)
            $0.width.equalToSuperview()
            $0.height.equalTo(imageCollectionView.snp.width)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(imageCollectionView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(12)
        }
        
        detailContent.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
        }
        
        detailContnetView.snp.makeConstraints {
            $0.top.equalTo(detailContent.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(100)
        }
        
        detailContnetView.addSubview(detailTextView)
        detailTextView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
}

extension DetailComplaintView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.frame.width != 0 else { return }
        
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
