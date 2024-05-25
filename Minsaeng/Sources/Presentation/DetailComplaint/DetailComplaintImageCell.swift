//
//  DetailComplaintImageCell.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/25.
//

import UIKit

final class DetailComplaintImageCell: UICollectionViewCell {
    static let reuseIdentifier = "DetailComplaintImageCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
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
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(image: String) {
        let image = UIImage(named: image)
        imageView.image = image
    }
}
