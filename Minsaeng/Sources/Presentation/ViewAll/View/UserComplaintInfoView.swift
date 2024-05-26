//
//  UserComplaintInfoView.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/20.
//

import UIKit

final class UserComplaintInfoView: UIView {
    
    private let userInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 3
        label.textColor = .MSDarkGray
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImage(named: "CommonIcon")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        setLabelAttribute(name: "홍길동", count: 56)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(userInfoLabel)
        addSubview(imageView)
        
        userInfoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(28)
        }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(28)
            $0.width.height.equalTo(100)
        }
    }
    
    func setLabelAttribute(name: String, count: Int) {
        let text = "\(name) 님\n지금까지 \(count)개 의\n신고 내역이 있어요!"
        let prevFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        let nextFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        let attributedString = NSMutableAttributedString(string: text,
                                                         attributes: [NSAttributedString.Key.font: prevFont])
        // 변경할 부분의 범위
        let nameRange = (text as NSString).range(of: "\(name)")
        let countRange = (text as NSString).range(of: "\(count)개")
        
        // 변경할 부분의 폰트, 컬러 변경
        attributedString.addAttribute(.font, value: nextFont, range: nameRange)
        attributedString.addAttribute(.font, value: nextFont, range: countRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.MSMain, range: nameRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.MSMain, range: countRange)
        
        // 행간 간격 설정
        setLineSpacing(to: attributedString, space: 12)

        userInfoLabel.attributedText = attributedString
    }
    
    private func setLineSpacing(to text: NSMutableAttributedString, space: CGFloat) {
        // 전체 텍스트에 행간 간격 적용
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        text.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: text.length))
    }
}
