//
//  AsyncResultPublisher.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/10/9.
//

import Combine

public struct AsyncResultPublisher<Output, Failure>: Publisher where Failure: Error {
    
    private let operation: () async -> Result<Output, Failure>
    private let cancelledErrorHandler: ((Failure) -> Void)?
    
    public init(
        operation: @escaping () async -> Result<Output, Failure>,
        cancelledErrorHandler: ((Failure) -> Void)?
    ) {
        self.operation = operation
        self.cancelledErrorHandler = cancelledErrorHandler
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = Subscription(
            operation: operation,
            resultHandler: {
                switch $0 {
                case .success(let output):
                    _ = subscriber.receive(output)
                    subscriber.receive(completion: .finished)
                case .failure(let error):
                    subscriber.receive(completion: .failure(error))
                }
            },
            cancelledErrorHandler: { cancelledErrorHandler?($0) }
        )
        subscriber.receive(subscription: subscription)
    }
    
    private class Subscription: Combine.Subscription {
        private let operation: () async -> Result<Output, Failure>
        private let resultHandler: (Result<Output, Failure>) -> Void
        private let cancelledErrorHandler: (Failure) -> Void
        
        private var task: Task<Void, Never>?
        
        init(
            operation: @escaping () async -> Result<Output, Failure>,
            resultHandler: @escaping (Result<Output, Failure>) -> Void,
            cancelledErrorHandler: @escaping (Failure) -> Void
        ) {
            self.operation = operation
            self.resultHandler = resultHandler
            self.cancelledErrorHandler = cancelledErrorHandler
        }
        
        func request(_ demand: Subscribers.Demand) {
            switch demand {
            case .none, .max(0):
                break
            default:
                task = Task {
                    let result = await operation()
                    if Task.isCancelled {
                        guard case .failure(let error) = result else { return }
                        cancelledErrorHandler(error)
                    } else {
                        resultHandler(result)
                    }
                }
            }
        }
        
        func cancel() {
            task?.cancel()
        }
    }
}
