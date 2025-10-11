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
    
    static let successString = "success"
    
    @Test
    func sendRequestAndCancel() throws {
        let store = TestViewStore(
            state: .init(),
            networkProvider: MockNetworkProvider()
        )
        #expect(try store.state.textResult.get() == "")
        #expect(!store.state.isLoading)
        
        store.send(.requestString)
        #expect(try store.state.textResult.get() == "")
        #expect(store.state.isLoading)
        
        store.send(.cancelRequestString)
        #expect(try store.state.textResult.get() == "")
        #expect(!store.state.isLoading)
    }
    
    @Test
    func updateRequest() throws {
        let store = TestViewStore(
            state: .init(isLoading: true),
            networkProvider: MockNetworkProvider()
        )
        #expect(try store.state.textResult.get() == "")
        #expect(store.state.isLoading)
        
        store.send(.updateString(.success(Self.successString)))
        #expect(try store.state.textResult.get() == Self.successString)
        #expect(!store.state.isLoading)
    }
}

extension ViewStoreTests {
    typealias RequestResult = Result<String, Error>
    
    struct State {
        var isLoading: Bool = false
        var textResult: Result<String, Error> = .success("")
    }
    
    enum Action {
        case requestString
        case cancelRequestString
        case updateString(RequestResult)
    }
    
    class TestViewStore: ViewStore<State, Action> {
        private let networkProvider: MockNetworkProvider
        
        enum TaskID {
            case longRequestString
        }
        
        init(
            state: State,
            networkProvider: MockNetworkProvider
        ) {
            self.networkProvider = networkProvider
            super.init(
                state: state,
                reducer: { state, action in
                    switch action {
                    case .requestString:
                        state.isLoading = true
                        return .task(id: TaskID.longRequestString) { send in
                            let result = await networkProvider.requestString()
                            send(.updateString(result))
                        }
                    case .cancelRequestString:
                        state.isLoading = false
                        return .cancel(id: TaskID.longRequestString)
                    case .updateString(let result):
                        state.isLoading = false
                        state.textResult = result.map { $0 }
                        return .none
                    }
                }
            )
        }
    }
    
    class MockNetworkProvider {
        
        func requestString() async -> RequestResult {
            do {
                try await Task.sleep(for: .seconds(3))
                return .success(successString)
            } catch {
                return .failure(error)
            }
        }
    }
}
