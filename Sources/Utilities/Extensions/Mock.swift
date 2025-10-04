//
//  Mock.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/10/4.
//

import Foundation

extension Data {
    
    public static func mock(jsonFile: String, bundle: Bundle) -> Data {
        let url = bundle.url(forResource: jsonFile, withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}

extension Decodable {
    
    public static func mock(jsonFile: String, bundle: Bundle) -> Self {
        return try! JSONDecoder().decode(Self.self, from: .mock(jsonFile: jsonFile, bundle: bundle))
    }
}
