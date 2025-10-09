//
//  AsyncResultPublisherTests.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/10/9.
//

import Testing
import Combine

@testable import Utilities

@Suite
struct AsyncResultPublisherTests {
    
    var cancellable: Cancellable?
    
    enum TestError: Error {
        case failed, cancelled, retry
    }
    
    @Test
    mutating func success() async {
        var value: Int?
        var isFinished = false
        var error: TestError?
        var cancelledError: TestError?
        
        await withCheckedContinuation { continuation in
            let publisher: AnyPublisher<Int, TestError> = Deferred {
                AsyncResultPublisher(
                    operation: {
                        await withCheckedContinuation { continuation in
                            continuation.resume(returning: .success(1))
                        }
                    },
                    cancelledErrorHandler: {
                        cancelledError = $0
                        continuation.resume()
                    }
                )
            }.eraseToAnyPublisher()
            
            cancellable = publisher
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            isFinished = true
                        case .failure(let _error):
                            error = _error
                        }
                        continuation.resume()
                    },
                    receiveValue: { _value in
                        value = _value
                    }
            )
        }
        
        #expect(value != nil)
        #expect(isFinished)
        #expect(error == nil)
        #expect(cancelledError == nil)
    }
    
    @Test
    mutating func failure() async {
        var value: Int?
        var isFinished = false
        var error: TestError?
        var cancelledError: TestError?
        
        await withCheckedContinuation { continuation in
            let publisher: AnyPublisher<Int, TestError> = Deferred {
                AsyncResultPublisher(
                    operation: {
                        await withCheckedContinuation { continuation in
                            continuation.resume(returning: .failure(.failed))
                        }
                    },
                    cancelledErrorHandler: {
                        cancelledError = $0
                        continuation.resume()
                    }
                )
            }.eraseToAnyPublisher()
            
            cancellable = publisher
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            isFinished = true
                        case .failure(let _error):
                            error = _error
                        }
                        continuation.resume()
                    },
                    receiveValue: { _value in
                        value = _value
                    }
                )
        }
        
        #expect(value == nil)
        #expect(!isFinished)
        #expect(error != nil)
        #expect(cancelledError == nil)
    }
    
    @Test
    mutating func cancelled() async {
        var value: Int?
        var isFinished = false
        var error: TestError?
        var cancelledError: TestError?
        
        await withCheckedContinuation { continuation in
            let publisher: AnyPublisher<Int, TestError> = Deferred {
                AsyncResultPublisher(
                    operation: {
                        do {
                            try await Task.sleep(for: .seconds(5))
                            return .success(1)
                        } catch {
                            return .failure(.cancelled)
                        }
                    },
                    cancelledErrorHandler: {
                        cancelledError = $0
                        continuation.resume()
                    }
                )
            }.eraseToAnyPublisher()
            
            cancellable = publisher
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            isFinished = true
                        case .failure(let _error):
                            error = _error
                        }
                        continuation.resume()
                    },
                    receiveValue: { _value in
                        value = _value
                    }
                )
            cancellable?.cancel()
        }
        
        #expect(value == nil)
        #expect(!isFinished)
        #expect(error == nil)
        #expect(cancelledError != nil)
    }
    
    @Test
    mutating func retry() async {
        var value: Int?
        var isFinished = false
        var error: TestError?
        var cancelledError: TestError?
        
        var countBeforeSuccess = 3
        
        await withCheckedContinuation { continuation in
            let publisher: AnyPublisher<Int, TestError> = Deferred {
                AsyncResultPublisher(
                    operation: {
                        await withCheckedContinuation { continuation in
                            if countBeforeSuccess > 0 {
                                countBeforeSuccess -= 1
                                continuation.resume(returning: .failure(.retry))
                            } else {
                                continuation.resume(returning: .success(1))
                            }
                        }
                    },
                    cancelledErrorHandler: {
                        cancelledError = $0
                        continuation.resume()
                    }
                )
            }.eraseToAnyPublisher()
            
            cancellable = publisher
                .retry(10)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            isFinished = true
                        case .failure(let _error):
                            error = _error
                        }
                        continuation.resume()
                    },
                    receiveValue: { _value in
                        value = _value
                    }
                )
        }
        
        #expect(value != nil)
        #expect(isFinished)
        #expect(error == nil)
        #expect(cancelledError == nil)
    }
}
