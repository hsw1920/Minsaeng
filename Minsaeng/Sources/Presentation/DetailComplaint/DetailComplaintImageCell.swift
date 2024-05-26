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
        imageView.contentMode = .scaleAspectFill
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
        
        imageView.image = nil
        imageView.backgroundColor = .clear
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(image: String) {
        if let image = loadImageFromDirectory(with: image) {
            // 이미지를 성공적으로 로드한 경우
            imageView.image = image
        } else {
            // 이미지를 로드하지 못한 경우
            print("Failed to load image")
            imageView.backgroundColor = .MSLightGray
        }
    }
    
    private func loadImageFromDirectory(with idnetifier: String) -> UIImage? {
        let fileManager = FileManager.default
        // 파일 경로로 접근
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(idnetifier, conformingTo: .jpeg)
        
        // 이미지 파일이 존재한다면, 이미지로 변환 후 리턴
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        
        return UIImage(contentsOfFile: fileURL.path)
    }
}
