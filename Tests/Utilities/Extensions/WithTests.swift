//
//  WithTests.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/8/22.
//

import Testing

@testable import Utilities

@Suite
struct WithTests {
    
    @Test
    func withForAny() {
        let testStruct = TestStruct().with {
            $0.number = 1
        }
        #expect(testStruct.number == 1)
    }
    
    @Test
    func doForAny() {
        TestClass().do {
            $0.setStaticString("1")
        }
        #expect(TestClass.string == "1")
    }
    
    @Test
    func withForAnyObject() {
        let testClass = TestClass().with {
            $0.number = 1
        }
        #expect(testClass.number == 1)
    }
}

extension WithTests {
    
    class TestClass: With {
        var number = 0
        
        static var string = ""
        
        func setStaticString(_ string: String) {
            Self.string = string
        }
    }
    
    struct TestStruct: With {
        var number = 0
    }
}
