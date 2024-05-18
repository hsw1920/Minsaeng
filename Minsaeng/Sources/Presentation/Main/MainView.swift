//
//  MainView.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/18.
//

import UIKit

final class MainView: UIView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delaysContentTouches = false
        return scrollView
    }()
    
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
    
    private let complaintView: UIView = {
        let view = UIView()
        view.backgroundColor = .MSBackgroundGray
        view.layer.cornerRadius = 12
        return view
    }()
    private let pinIcon: UILabel = {
        let label = UILabel()
        label.text = "📌"
        label.font = .systemFont(ofSize: 28)
        return label
    }()
    private let complaintDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "불법 주정차된 차량을\n촬영하여 신고할 수 있어요"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .MSBlack
        return label
    }()
    let complaintButton: UIButton = {
        let button = UIButton()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 35)
        let image = UIImage(systemName: "camera.circle.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        
        button.setTitle("신고하기", for: .normal)
        button.setTitleColor(.MSWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        button.setBackgroundColor(.MSMain, for: .normal)
        button.setBackgroundColor(.MSLightMain, for: .highlighted)
        
        button.tintColor = .MSWhite
        
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
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
        
        [complaintView].forEach { contentView.addSubview($0) }

        [pinIcon, complaintDescriptionLabel, complaintButton].forEach { complaintView.addSubview($0) }
        
        complaintView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(21)
            $0.height.equalTo(200)
        }
        
        pinIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(32)
        }
        
        complaintDescriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(pinIcon.snp.trailing).offset(12)
            $0.top.equalTo(pinIcon)
        }
        
        complaintButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
            $0.height.equalTo(62)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}
