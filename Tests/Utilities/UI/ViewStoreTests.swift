//
//  ViewStoreTests.swift
//  swift-utilities
//
//  Created by 陸瑋恩 on 2025/9/7.
//

import Testing
import Foundation

@testable import Utilities

@Suite
struct ViewStoreTests {
    
    @Test
    func success() {
        let successText = "success"
        let store = TestViewStore(networkProvider: MockNetworkProvider(mockResult: .success(successText)))
        
        #expect(!store.state.isLoading)
        if case .success(let text) = store.state.textResult {
            #expect(text == nil)
        } else {
            #expect(Bool(false))
        }
        
        store.send(.fetchString)
        #expect(store.state.isLoading)
    }
}

extension ViewStoreTests {
    
    struct State {
        var isLoading: Bool = false
        var textResult: Result<String?, Error> = .success(nil)
    }
    
    enum Action {
        case fetchString
        case updateString(Result<String, Error>)
    }
    
    class TestViewStore: ViewStore<State, Action> {
        private let networkProvider: MockNetworkProvider
        
        init(networkProvider: MockNetworkProvider) {
            self.networkProvider = networkProvider
            super.init(
                state: .init(),
                reducer: { state, action in
                    switch action {
                    case .fetchString:
                        state.isLoading = true
                        return .run { send in
                            let result = await networkProvider.fetchString()
                            send(.updateString(result))
                        }
                    case .updateString(let result):
                        state.isLoading = false
                        state.textResult = result.map { $0 }
                        return nil
                    }
                }
            )
        }
    }
    
    class MockNetworkProvider {
        
        let mockResult: Result<String, Error>
        
        init(mockResult: Result<String, Error>) {
            self.mockResult = mockResult
        }
        
        func fetchString() async -> Result<String, Error> {
            return mockResult
        }
    }
}
