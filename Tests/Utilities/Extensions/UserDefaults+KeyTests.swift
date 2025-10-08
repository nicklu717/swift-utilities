//
//  UserDefaults+KeyTests.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/10/8.
//

import Testing
import Foundation

@testable import Utilities

@Suite
struct UserDefaultsKeyTests {
    
    let userDefaults: UserDefaults = MockUserDefaults()
    
    @Test
    func getAndSetString() {
        #expect(userDefaults[.testKey] == nil)
        
        let testValue = "testValue"
        userDefaults[.testKey] = testValue
        #expect(userDefaults[.testKey] == testValue)
    }
    
    @Test
    func getAndSetInt() {
        #expect(userDefaults[.testKey] == nil)
        
        let testValue = 123
        userDefaults[.testKey] = testValue
        #expect(userDefaults[.testKey] == testValue)
    }
}

extension UserDefaultsKeyTests {
    
    class MockUserDefaults: UserDefaults {
        private var dict: [String: Any] = [:]
        
        override func object(forKey defaultName: String) -> Any? {
            return dict[defaultName]
        }
        
        override func set(_ value: Any?, forKey defaultName: String) {
            dict[defaultName] = value
        }
    }
}

extension UserDefaults.Key {
    
    static let testKey: Self = "testKey"
}
