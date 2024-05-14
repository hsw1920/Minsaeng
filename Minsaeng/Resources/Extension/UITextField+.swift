//
//  UITextField+.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/14.
//

import UIKit

extension UITextField {
    func addPaddingLeft(_ padding: CGFloat) {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftViewMode = .always
    }
}
