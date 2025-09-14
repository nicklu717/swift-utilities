//
//  Array+SafeTests.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/9/14.
//

import Testing

@testable import Utilities

struct ArraySafeTest {
    
    let numbers = [0, 1, 2]

    @Test
    func elementExist() {
        #expect(numbers[safe: 2] != nil)
    }
    
    @Test
    func elementNotExist() {
        #expect(numbers[safe: 3] == nil)
    }
    
    @Test
    func negativeIndex() {
        #expect(numbers[safe: -3] == nil)
    }
}
