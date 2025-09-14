//
//  Array+Safe.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/9/14.
//

extension Array {
    
    public subscript(safe index: Index) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}
