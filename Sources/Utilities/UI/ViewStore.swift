//
//  ViewStore.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/9/7.
//

import SwiftUI
import Combine

open class ViewStore<State, Action>: ObservableObject {
    
    public typealias Reducer = (inout State, Action) -> Effect
    
    @Published private(set) public var state: State
    
    private let reducer: Reducer
    
    private var cancellables: [AnyHashable: AnyCancellable] = [:]
    
    public init(state: State, reducer: @escaping Reducer) {
        self.state = state
        self.reducer = reducer
    }
    
    public func send(_ action: Action) {
        let effect = reducer(&state, action)
        switch effect {
        case .task(let id, let operation):
            let task = Task { await operation(send) }
            if let id {
                set(cancellable: AnyCancellable(task), forID: id)
            }
        case .publisher(let id, let getPublisher):
            let cancellable = getPublisher()
                .receive(on: DispatchQueue.main)
                .sink { [unowned self] in
                    self.send($0)
                }
            if let id {
                set(cancellable: cancellable, forID: id)
            }
        case .cancel(let id):
            set(cancellable: nil, forID: id)
        case .none:
            break
        }
    }
    
    private func set(cancellable: AnyCancellable?, forID id: AnyHashable) {
        cancellables[id]?.cancel()
        cancellables[id] = cancellable
    }
}

extension Task: @retroactive Cancellable {}

// MARK: - Effect
extension ViewStore {
    
    public enum Effect {
        case task(id: AnyHashable? = nil, _ operation: (_ send: (Action) -> Void) async -> Void)
        case publisher(id: AnyHashable? = nil, _ getPublisher: () -> AnyPublisher<Action, Never>)
        case cancel(id: AnyHashable)
        case none
    }
}
