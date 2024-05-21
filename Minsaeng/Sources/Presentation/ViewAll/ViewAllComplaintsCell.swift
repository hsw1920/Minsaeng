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
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    
    private func setupUI() {
        contentView.addSubview(thumbnail)
        
        thumbnail.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(item: Complaint) {
        let randomImage = ["CommonIcon", "ProfileComplete", "ProfileStep1", "ProfileStep2"]
        
        let image = UIImage(named: randomImage.randomElement()!)
        thumbnail.image = image
    }
}
