//
//  MainView.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/18.
//

import UIKit

final class MainView: UIView {
    
    private let scrollView: UIScrollView = .init()
    private let contentView: UIView = .init()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "홈"
        label.textColor = .MSBlack
        label.font = .systemFont(ofSize: 26, weight: .medium)
        return label
    }()
    
    let profileButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: "person.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .MSBlack
        return button
    }()
    
    let complaintButton: UIButton = {
        let button = UIButton()
        button.setTitle("메시지 생성", for: .normal)
        button.setTitleColor(.MSBlack, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        self.addSubview(complaintButton)
        complaintButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}
