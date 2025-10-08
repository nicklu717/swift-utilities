//
//  UIFont+Famliy.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/5/27.
//

#if canImport(UIKit)
import UIKit

extension UIFont {
    
    public static func custom(_ family: Family, size: CGFloat, weight: Weight = .regular) -> UIFont {
        return family.font(size: size, weight: weight)
    }
    
    public enum Family: String {
        case pingFangTC = "PingFangTC"

        func font(size: CGFloat, weight: Weight = .regular) -> UIFont {
            return UIFont(name: "\(rawValue)-\(familyWeight(for: weight))", size: size)!
        }

        private func familyWeight(for weight: Weight) -> String {
            switch self {
            case .pingFangTC:
                switch weight {
                case .ultraLight:
                    return "Ultralight"
                case .light:
                    return "Light"
                case .thin:
                    return "Thin"
                case .regular:
                    return "Regular"
                case .medium:
                    return "Medium"
                case .semibold, .heavy, .black:
                    return "Semibold"
                default:
                    return "Regular"
                }
            }
        }
    }
}
#endif
