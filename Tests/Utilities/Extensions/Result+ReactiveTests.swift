//
//  Result+ReactiveTests.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/8/22.
//

import Testing

@testable import Utilities

@Suite
struct ResultReactiveTests {
    
    enum SomeError: Error {
        case someFailure1
        case someFailure2
    }
    
    enum SomeOtherError: Error {
        case someOtherFailure
    }
    
    @Suite
    struct AsyncMap {
        let number = 42
        
        @Test
        func onSuccess() async {
            let result: Result<Int, SomeError> = .success(number)
            let transformedResult: Result<String, SomeError> = await result
                .asyncMap { value in
                    return await withCheckedContinuation { continuation in
                        continuation.resume(returning: String(value))
                    }
                }
            let expectedResult: Result<String, SomeError> = .success(String(number))
            #expect(transformedResult == expectedResult)
        }
        
        @Test
        func onFailure() async {
            let result: Result<Int, SomeError> = .failure(.someFailure1)
            let transformedResult: Result<String, SomeError> = await result
                .asyncMap { value in
                    return await withCheckedContinuation { continuation in
                        continuation.resume(returning: String(value))
                    }
                }
            let expectedResult: Result<String, SomeError> = .failure(.someFailure1)
            #expect(transformedResult == expectedResult)
        }
    }
    
    @Suite
    struct AsyncMapError {
        
        @Test
        func onSuccess() async {
            let number = 42
            let result: Result<Int, SomeError> = .success(number)
            let transformedResult: Result<Int, SomeOtherError> = await result
                .asyncMapError { error in
                    return await withCheckedContinuation { continuation in
                        continuation.resume(returning: .someOtherFailure)
                    }
                }
            let expectedResult: Result<Int, SomeOtherError> = .success(number)
            #expect(transformedResult == expectedResult)
        }
        
        @Test
        func onFailure() async {
            let result: Result<Int, SomeError> = .failure(.someFailure1)
            let transformedResult: Result<Int, SomeOtherError> = await result
                .asyncMapError { error in
                    return await withCheckedContinuation { continuation in
                        continuation.resume(returning: .someOtherFailure)
                    }
                }
            let expectedResult: Result<Int, SomeOtherError> = .failure(.someOtherFailure)
            #expect(transformedResult == expectedResult)
        }
    }
    
    @Suite
    struct AsyncFlatMap {
        let number = 42
        
        @Test
        func successToSuccess() async {
            let result: Result<Int, SomeError> = .success(number)
            let transformedResult: Result<String, SomeError> = await result
                .asyncFlatMap { value in
                    return await withCheckedContinuation { continuation in
                        continuation.resume(returning: .success(String(value)))
                    }
                }
            let expectedResult: Result<String, SomeError> = .success(String(number))
            #expect(transformedResult == expectedResult)
        }
        
        @Test
        func successToFailure() async {
            let result: Result<Int, SomeError> = .success(number)
            let transformedResult: Result<String, SomeError> = await result
                .asyncFlatMap { value in
                    return await withCheckedContinuation { continuation in
                        continuation.resume(returning: .failure(.someFailure1))
                    }
                }
            let expectedResult: Result<String, SomeError> = .failure(.someFailure1)
            #expect(transformedResult == expectedResult)
        }
        
        @Test
        func failureToSuccess() async {
            let result: Result<Int, SomeError> = .failure(.someFailure1)
            let transformedResult: Result<String, SomeError> = await result
                .asyncFlatMap { value in
                    return await withCheckedContinuation { continuation in
                        continuation.resume(returning: .success(String(value)))
                    }
                }
            let expectedResult: Result<String, SomeError> = .failure(.someFailure1)
            #expect(transformedResult == expectedResult)
        }
        
        @Test
        func failureToFailure() async {
            let result: Result<Int, SomeError> = .failure(.someFailure1)
            let transformedResult: Result<String, SomeError> = await result
                .asyncFlatMap { value in
                    return await withCheckedContinuation { continuation in
                        continuation.resume(returning: .failure(.someFailure2))
                    }
                }
            let expectedResult: Result<String, SomeError> = .failure(.someFailure1)
            #expect(transformedResult == expectedResult)
        }
    }
    
    @Suite
    struct AsyncFlatMapError {
        let number = 42
        
        @Test
        func successToSuccess() async {
            let result: Result<Int, SomeError> = .success(number)
            let transformedResult: Result<Int, SomeOtherError> = await result
                .asyncFlatMapError { error in
                    return await withCheckedContinuation { continuation in
                        continuation.resume(returning: .success(number * 2))
                    }
                }
            let expectedResult: Result<Int, SomeOtherError> = .success(number)
            #expect(transformedResult == expectedResult)
        }
        
        @Test
        func successToFailure() async {
            let result: Result<Int, SomeError> = .success(number)
            let transformedResult: Result<Int, SomeOtherError> = await result
                .asyncFlatMapError { error in
                    return await withCheckedContinuation { continuation in
                        continuation.resume(returning: .failure(.someOtherFailure))
                    }
                }
            let expectedResult: Result<Int, SomeOtherError> = .success(number)
            #expect(transformedResult == expectedResult)
        }
        
        @Test
        func failureToSuccess() async {
            let result: Result<Int, SomeError> = .failure(.someFailure1)
            let transformedResult: Result<Int, SomeOtherError> = await result
                .asyncFlatMapError { error in
                    return await withCheckedContinuation { continuation in
                        continuation.resume(returning: .success(number * 2))
                    }
                }
            let expectedResult: Result<Int, SomeOtherError> = .success(number * 2)
            #expect(transformedResult == expectedResult)
        }
        
        @Test
        func failureToFailure() async {
            let result: Result<Int, SomeError> = .failure(.someFailure1)
            let transformedResult: Result<Int, SomeOtherError> = await result
                .asyncFlatMapError { error in
                    return await withCheckedContinuation { continuation in
                        continuation.resume(returning: .failure(.someOtherFailure))
                    }
                }
            let expectedResult: Result<Int, SomeOtherError> = .failure(.someOtherFailure)
            #expect(transformedResult == expectedResult)
        }
    }
    
    @Suite
    struct onSuccess {
        
        @Test
        func success() throws {
            let number = 42
            let result: Result<Int, SomeError> = .success(number)
            var expectedNumber: Int?
            let actionedResult = result
                .onSuccess { value in
                    expectedNumber = value
                }
            #expect(actionedResult == result)
            let unwrappedExpectedNumber = try #require(expectedNumber)
            #expect(unwrappedExpectedNumber == number)
        }
        
        @Test
        func failure() {
            let result: Result<Int, SomeError> = .failure(.someFailure1)
            var expectedNumber: Int?
            let actionedResult = result
                .onSuccess { value in
                    expectedNumber = value
                }
            #expect(actionedResult == result)
            #expect(expectedNumber == nil)
        }
    }
    
    @Suite
    struct onFailure {
        
        @Test
        func success() {
            let number = 42
            let result: Result<Int, SomeError> = .success(number)
            var expectedError: SomeError?
            let actionedResult = result
                .onFailure { error in
                    expectedError = error
                }
            #expect(actionedResult == result)
            #expect(expectedError == nil)
        }
        
        @Test
        func failure() throws {
            let result: Result<Int, SomeError> = .failure(.someFailure1)
            var expectedError: SomeError?
            let actionedResult = result
                .onFailure { error in
                    expectedError = error
                }
            #expect(actionedResult == result)
            let unwrappedExpectedError = try #require(expectedError)
            #expect(unwrappedExpectedError == .someFailure1)
        }
    }
}
