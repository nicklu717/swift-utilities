//
//  Result+Reactive.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/8/22.
//

public extension Result {
    
    func asyncMap<NewSuccess>(_ transform: (Success) async -> NewSuccess) async -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let success):
            return await .success(transform(success))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func asyncMapError<NewFailure>(_ transform: (Failure) async -> NewFailure) async -> Result<Success, NewFailure> {
        switch self {
        case .success(let success):
            return .success(success)
        case .failure(let failure):
            return await .failure(transform(failure))
        }
    }
    
    func asyncFlatMap<NewSuccess>(_ transform: (Success) async -> Result<NewSuccess, Failure>) async -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let success):
            return await transform(success)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func asyncFlatMapError<NewFailure>(_ transform: (Failure) async -> Result<Success, NewFailure>) async -> Result<Success, NewFailure> {
        switch self {
        case .success(let success):
            return .success(success)
        case .failure(let failure):
            return await transform(failure)
        }
    }
    
    @discardableResult
    func onSuccess(_ action: (Success) -> Void) -> Result<Success, Failure> {
        if case .success(let success) = self {
            action(success)
        }
        return self
    }
    
    @discardableResult
    func onFailure(_ action: (Failure) -> Void) -> Result<Success, Failure> {
        if case .failure(let failure) = self {
            action(failure)
        }
        return self
    }
}
