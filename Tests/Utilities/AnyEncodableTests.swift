//
//  AnyEncodableTests.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/8/22.
//

import Testing
import Foundation

@testable import Utilities

@Suite
struct AnyEncodableTests {
    
    let jsonEncoder = JSONEncoder()
    
    @Test
    func string() throws {
        let testString: String? = "Hello, World!"
        let anyEncodable: AnyEncodable = .string(testString)
        let data = try jsonEncoder.encode(anyEncodable)
        
        let expectedData = try jsonEncoder.encode(testString)
        #expect(data == expectedData)
    }
    
    @Test
    func nilString() throws {
        let testString: String? = nil
        let anyEncodable: AnyEncodable = .string(testString)
        let data = try jsonEncoder.encode(anyEncodable)
        
        let expectedData = try jsonEncoder.encode(testString)
        #expect(data == expectedData)
    }
    
    @Test
    func int() throws {
        let testInt: Int? = 42
        let anyEncodable: AnyEncodable = .int(testInt)
        let data = try jsonEncoder.encode(anyEncodable)
        
        let expectedData = try jsonEncoder.encode(testInt)
        #expect(data == expectedData)
    }
    
    @Test
    func nilInt() throws {
        let testInt: Int? = 42
        let anyEncodable: AnyEncodable = .int(testInt)
        let data = try jsonEncoder.encode(anyEncodable)
        
        let expectedData = try jsonEncoder.encode(testInt)
        #expect(data == expectedData)
    }
    
    @Test
    func double() throws {
        let testDouble: Double? = 3.14
        let anyEncodable: AnyEncodable = .double(testDouble)
        let data = try jsonEncoder.encode(anyEncodable)
        
        let expectedData = try jsonEncoder.encode(testDouble)
        #expect(data == expectedData)
    }
    
    @Test
    func nilDouble() throws {
        let testDouble: Double? = 3.14
        let anyEncodable: AnyEncodable = .double(testDouble)
        let data = try jsonEncoder.encode(anyEncodable)
        
        let expectedData = try jsonEncoder.encode(testDouble)
        #expect(data == expectedData)
    }
    
    @Test
    func bool() throws {
        let testBool: Bool? = true
        let anyEncodable: AnyEncodable = .bool(testBool)
        let data = try jsonEncoder.encode(anyEncodable)
        
        let expectedData = try jsonEncoder.encode(testBool)
        #expect(data == expectedData)
    }
    
    @Test
    func nilBool() throws {
        let testBool: Bool? = true
        let anyEncodable: AnyEncodable = .bool(testBool)
        let data = try jsonEncoder.encode(anyEncodable)
        
        let expectedData = try jsonEncoder.encode(testBool)
        #expect(data == expectedData)
    }
    
    @Test
    func array() throws {
        let testArray: [AnyEncodable]? = [.string("Hello"), .int(42), .double(3.14), .bool(true)]
        let anyEncodable: AnyEncodable = .array(testArray)
        let data = try jsonEncoder.encode(anyEncodable)
        
        let expectedData = try jsonEncoder.encode(testArray)
        #expect(data == expectedData)
    }
    
    @Test
    func arrayWithNil() throws {
        let testArray: [AnyEncodable]? = [.string("Hello"), .int(nil), .nil, .bool(nil)]
        let anyEncodable: AnyEncodable = .array(testArray)
        let data = try jsonEncoder.encode(anyEncodable)
        
        let expectedData = try jsonEncoder.encode(testArray)
        #expect(data == expectedData)
    }
    
    @Test
    func nilArray() throws {
        let testArray: [AnyEncodable]? = nil
        let anyEncodable: AnyEncodable = .array(testArray)
        let data = try jsonEncoder.encode(anyEncodable)
        
        let expectedData = try jsonEncoder.encode(testArray)
        #expect(data == expectedData)
    }
    
    @Test
    func dictionary() throws {
        let testDictionary: [String: AnyEncodable] = [
            "name": .string("John Doe"),
            "age": .int(30),
            "isActive": .bool(true),
            "scores": .array([.double(95.5), .double(88.0)]),
            "details": .dictionary(["weight": .double(70.0), "height": .int(175)])
        ]
        let anyEncodable: AnyEncodable = .dictionary(testDictionary)
        let data = try jsonEncoder.encode(anyEncodable)
        
        let expectedData = try jsonEncoder.encode(testDictionary)
        #expect(data.count == expectedData.count)
    }
    
    @Test
    func dictionaryWithNil() throws {
        let testDictionary: [String: AnyEncodable] = [
            "name": .string("John Doe"),
            "age": .int(nil),
            "isActive": .nil,
            "scores": .array([.double(95.5), .double(88.0)]),
            "details": .dictionary(["weight": .double(nil), "height": .int(175)])
        ]
        let anyEncodable: AnyEncodable = .dictionary(testDictionary)
        let data = try jsonEncoder.encode(anyEncodable)
        
        let expectedData = try jsonEncoder.encode(testDictionary)
        #expect(data.count == expectedData.count)
    }
    
    @Test
    func nilDictionary() throws {
        let testDictionary: [String: AnyEncodable]? = nil
        let anyEncodable: AnyEncodable = .dictionary(testDictionary)
        let data = try jsonEncoder.encode(anyEncodable)
        
        let expectedData = try jsonEncoder.encode(testDictionary)
        #expect(data.count == expectedData.count)
    }
}
