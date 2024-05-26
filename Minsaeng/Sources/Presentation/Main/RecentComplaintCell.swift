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
        imageView.contentMode = .scaleAspectFill
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
        
        photoView.image = nil
        photoView.backgroundColor = .clear
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
        let formatter = MSDateFormatter()
        let dateString = formatter.getY4M2D4(date: item.date)
        dateLabel.text = dateString
        violationTypeLabel.text = item.violationType.toString
        
        if let image = loadImageFromDirectory(with: item.image) {
            // 이미지를 성공적으로 로드한 경우
            photoView.image = image
        } else {
            // 이미지를 로드하지 못한 경우
            print("Failed to load image")
            photoView.backgroundColor = .MSLightGray
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
