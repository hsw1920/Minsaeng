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
  
    private let infoView: UIView = UserComplaintInfoView()
    
    
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
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        layout.itemSize = CGSize(width: (self.bounds.width - 2) / 3,
                                 height: (self.bounds.width - 2) / 3)
        complaintsCollectionView.collectionViewLayout = layout
        
        let dataCounts = complaintsCollectionView.numberOfItems(inSection: 0)
        updateContentViewHeight(by: dataCounts)
    }
    
    func updateContentViewHeight(by dataCounts: Int) {
        let cellSize: CGFloat = (self.bounds.width - 2) / 3.0
        let collectionViewHeight = CGFloat(Int(dataCounts / 3)) * cellSize
        complaintsCollectionView.snp.updateConstraints {
            $0.height.equalTo(collectionViewHeight)
        }
    }
}
