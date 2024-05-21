//
//  ViewAllView.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/20.
//

import UIKit

final class ViewAllView: UIView {
    deinit {
        print("deinit: \(self)")
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delaysContentTouches = false
        return scrollView
    }()
    
    private let contentView: UIView = .init()
  
    let infoView: UserComplaintInfoView = UserComplaintInfoView()
    
    private let complaintDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "불법 주정차된 차량을\n촬영하여 신고할 수 있어요"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .MSBlack
        return label
    }()
    
    let complaintsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(ViewAllComplaintsCell.self,
                                forCellWithReuseIdentifier: ViewAllComplaintsCell.reuseIdentifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        complaintsCollectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        updateCollectionViewLayout()
    }
    
    private func setupUI() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [infoView,
         complaintsCollectionView
        ].forEach {
            contentView.addSubview($0)
        }
        
        infoView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(155)
        }
        
        complaintsCollectionView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0)
        }
    }
    
    private func updateCollectionViewLayout() {
        let itemSpacing: CGFloat = 1
        let width: CGFloat = (bounds.width - itemSpacing * 2) / 3
        let dataCounts = complaintsCollectionView.numberOfItems(inSection: 0)
        var itemSpacingCount: Int = (dataCounts - 1) / 3
        var itemSpacingHeight: CGFloat = CGFloat(itemSpacingCount) * itemSpacing
        var itemHeight: CGFloat = CGFloat(itemSpacingCount + 1) * width
        var collectionViewHeight: CGFloat = itemSpacingHeight + itemHeight

        complaintsCollectionView.snp.updateConstraints {
            $0.height.equalTo(collectionViewHeight)
        }
    }
}

extension ViewAllView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 1
        let width: CGFloat = (collectionView.bounds.width - itemSpacing * 2) / 3

        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
