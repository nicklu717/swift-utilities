//
//  AnyEncodable.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/8/22.
//

public enum AnyEncodable: Encodable {
    case string(String?)
    case int(Int?)
    case double(Double?)
    case bool(Bool?)
    case array([AnyEncodable]?)
    case dictionary([String: AnyEncodable]?)
    case `nil`
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let string):
            if let string {
                try container.encode(string)
            } else {
                try container.encodeNil()
            }
        case .int(let int):
            if let int {
                try container.encode(int)
            } else {
                try container.encodeNil()
            }
        case .double(let double):
            if let double {
                try container.encode(double)
            } else {
                try container.encodeNil()
            }
        case .bool(let bool):
            if let bool {
                try container.encode(bool)
            } else {
                try container.encodeNil()
            }
        case .array(let array):
            if let array {
                try container.encode(array)
            } else {
                try container.encodeNil()
            }
        case .dictionary(let dictionary):
            if let dictionary {
                try container.encode(dictionary)
            } else {
                try container.encodeNil()
            }
        case .nil:
            try container.encodeNil()
        }
    }
}
