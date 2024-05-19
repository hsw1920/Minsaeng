//
//  RecentComplaintCell.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/18.
//

import UIKit

final class RecentComplaintCell: UICollectionViewCell {
    static let reuseIdentifier = "RecentComplaintCell"

    let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .MSBackgroundGray
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let violationTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .MSBlack
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .MSDarkGray
        return label
    }()

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 12
        contentView.layer.borderColor = UIColor.MSBorderGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.clipsToBounds = true
        
        [photoView, violationTypeLabel, dateLabel].forEach { contentView.addSubview($0) }
        
        photoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(124)
        }
        
        violationTypeLabel.snp.makeConstraints {
            $0.top.equalTo(photoView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configure(item: RecentComplaint) {
        violationTypeLabel.text = item.violationType.toString
        dateLabel.text = item.date.description
    }
}
