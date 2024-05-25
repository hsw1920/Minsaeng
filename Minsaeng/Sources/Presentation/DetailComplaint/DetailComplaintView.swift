//
//  DetailComplaintView.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/21.
//

import UIKit

final class DetailComplaintView: UIView {
    deinit {
        print("deinit: \(self)")
    }
    
    let exitButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .MSBlack
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "라벨"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .MSBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
