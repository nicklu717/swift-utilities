//
//  UserDefaults+Key.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/10/8.
//

import Foundation

extension UserDefaults {
    
    public subscript<T>(_ key: Key) -> T? {
        get { object(forKey: key.value) as? T }
        set { set(newValue, forKey: key.value) }
    }
    
    public struct Key: ExpressibleByStringLiteral {
        let value: String
        
        public init(stringLiteral value: String) {
            self.value = value
        }
    }
}
