//
//  UIColor+Decimal.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/5/27.
//

#if canImport(UIKit)
import UIKit

public extension UIColor {

    static func decimal(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
    static func decimal(white: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(white: white / 255, alpha: alpha)
    }
}
#endif
