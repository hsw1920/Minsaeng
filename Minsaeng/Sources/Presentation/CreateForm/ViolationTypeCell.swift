//
//  ViolationTypeCell.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/04/21.
//

import UIKit

struct ViolationType {
    let title: String
    let description: String
    var isSelected: Bool
    
    static let mock: [ViolationType] = [
        ViolationType(title: "소화전", description: "소화전에 불법주정차", isSelected: false),
        ViolationType(title: "교차로 모퉁이", description: "교차로 모퉁이에 불법주정차", isSelected: false),
        ViolationType(title: "버스 정류소", description: "버스 정류소에 불법주정차", isSelected: false),
        ViolationType(title: "횡단보도", description: "횡단보도에 불법주정차", isSelected: false),
        ViolationType(title: "어린이 보호구역", description: "어린이 보호구역에 불법주정차", isSelected: false),
        ViolationType(title: "인도", description: "인도에 불법주정차", isSelected: false),
        ViolationType(title: "기타", description: "해당 상황으로 불법 주정차", isSelected: false),
    ]
}

final class ViolationTypeCell: UICollectionViewCell {
    static let reuseIdentifier = "ViolationTypeCell"

    private let titleLabel: UILabel = .init()

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
        
        contentView.backgroundColor = .white
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.borderColor = UIColor.darkGray.cgColor
        contentView.layer.borderWidth = 1
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(type: ViolationType) {
        titleLabel.text = type.title
        if type.isSelected {
            contentView.backgroundColor = .systemYellow
        }
    }
}
