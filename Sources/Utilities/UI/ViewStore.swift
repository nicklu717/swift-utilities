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
    
    private var tasks: [AnyHashable: Task<Void, Never>] = [:]
    
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
                set(task: task, id: id)
            }
        case .cancel(let id):
            set(task: nil, id: id)
        case .none:
            break
        }
    }
    
    private func set(task: Task<Void, Never>?, id: AnyHashable) {
        tasks[id]?.cancel()
        tasks[id] = task
    }
}

// MARK: - Effect
extension ViewStore {
    
    public enum Effect {
        case task(id: AnyHashable?, _ operation: (_ send: (Action) -> Void) async -> Void)
        case cancel(id: AnyHashable)
        case none
    }
}
