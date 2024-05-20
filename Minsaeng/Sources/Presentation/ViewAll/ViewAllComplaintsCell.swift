//
//  ViewAllComplaintsCell.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/20.
//

import UIKit

final class ViewAllComplaintsCell: UICollectionViewCell {
    static let reuseIdentifier = "ViewAllComplaintsCell"

    private let thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .MSBackgroundGray
        return imageView
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
        
        contentView.backgroundColor = .MSLightGray
    }
    
    private func setupUI() {
        contentView.addSubview(thumbnail)
        
        thumbnail.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(item: Complaint) {
        thumbnail.backgroundColor = [UIColor.MSGray, UIColor.MSMain, UIColor.MSWarning].randomElement()
    }
}
