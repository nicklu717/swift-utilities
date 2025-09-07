//
//  ViewStore.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/9/7.
//

import SwiftUI

open class ViewStore<State, Action>: ObservableObject {
    
    @Published private(set) public var state: State
    
    private let reducer: (inout State, Action) -> Effect?
    
    private var runningTasks: [AnyHashable: Task<Void, Never>] = [:]
    
    public init(state: State, reducer: @escaping (inout State, Action) -> Effect?) {
        self.state = state
        self.reducer = reducer
    }
    
    public func send(_ action: Action) {
        guard let effect = reducer(&state, action) else { return }
        switch effect {
        case .run(let cancelID, let operation):
            let task = Task { await operation(send) }
            if let cancelID {
                runningTasks[cancelID]?.cancel()
                runningTasks[cancelID] = task
            }
        case .cancel(let id):
            runningTasks[id]?.cancel()
            runningTasks[id] = nil
        }
    }
}

// MARK: - Effect
extension ViewStore {
    
    public enum Effect {
        case run(cancelID: AnyHashable? = nil, _ operation: (_ send: (Action) -> Void) async -> Void)
        case cancel(id: AnyHashable)
    }
}
