//
//  UIColor+.swift
//  Minsaeng
//
//  Created by 홍승완 on 2024/05/14.
//

import UIKit

extension UIColor {
    class var MSMain: UIColor { return UIColor(hex: 0x4AA8FF) }
    class var MSLightMain: UIColor { return UIColor(hex: 0x88CCFF) }
    class var MSWarning: UIColor { return UIColor(hex: 0xFF8676) }
    class var MSBlack: UIColor { return UIColor(hex: 0x111111) }
    class var MSDarkGray: UIColor { return UIColor(hex: 0x767676) }
    class var MSGray: UIColor { return UIColor(hex: 0xD9D9D9) }
    class var MSLightGray: UIColor { return UIColor(hex: 0xFAFAFA) }
    class var MSWhite: UIColor { return UIColor(hex: 0xFFFFFF) }
    class var MSBackgroundGray: UIColor { return UIColor(hex: 0xF5F5F9) }
    class var MSBorderGray: UIColor { return UIColor(hex: 0xD9D9D9) }
}

// MARK: UIColor extension: "hex 값으로 Color를 세팅합니다."
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
    
    // let's suppose alpha is the first component (ARGB)
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }
}
