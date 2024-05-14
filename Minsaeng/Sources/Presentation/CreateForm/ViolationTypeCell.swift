//
//  ViolationTypeCell.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/21.
//

import UIKit

struct ViolationType {
    let title: String
    var isSelected: Bool
    
    static let mock: [ViolationType] = [
        ViolationType(title: "소화전", isSelected: false),
        ViolationType(title: "교차로 모퉁이", isSelected: false),
        ViolationType(title: "버스 정류소", isSelected: false),
        ViolationType(title: "횡단보도", isSelected: false),
        ViolationType(title: "어린이 보호구역", isSelected: false),
        ViolationType(title: "인도", isSelected: false),
        ViolationType(title: "기타", isSelected: false),
    ]
}

final class ViolationTypeCell: UICollectionViewCell {
    static let reuseIdentifier = "ViolationTypeCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
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
        
        contentView.backgroundColor = .MSLightGray
        titleLabel.textColor = .MSDarkGray
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 12
        contentView.layer.borderColor = UIColor.MSBorderGray.cgColor
        contentView.layer.borderWidth = 1
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(type: ViolationType) {
        titleLabel.text = type.title
        if type.isSelected {
            contentView.backgroundColor = .MSMain
            titleLabel.textColor = .MSWhite
        }
    }
}
