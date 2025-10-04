//
//  With.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/8/22.
//

import ObjectiveC

extension NSObject: With {}

public protocol With {}

public extension With where Self: Any {
    
    /// ```swift
    /// let frame = CGRect().with {
    ///     $0.origin.x = 10
    ///     $0.size.width = 100
    /// }
    /// ```
    func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
    
    /// ```swift
    /// UserDefaults.standard.do {
    ///     $0.set("nicklu717", forKey: "username")
    ///     $0.set("nicklu717@gmail.com", forKey: "email")
    ///     $0.synchronize()
    /// }
    /// ```
    func `do`(_ block: (Self) throws -> Void) rethrows {
        try block(self)
    }
}

public extension With where Self: AnyObject {
    
    /// ```swift
    /// let label = UILabel().with {
    ///     $0.textAlignment = .center
    ///     $0.textColor = UIColor.black
    ///     $0.text = "Hello, World!"
    /// }
    /// ```
    func with(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}
