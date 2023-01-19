//
//  EffectsRefreshableView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/19.
//

import SwiftUI

import ComposableArchitecture

struct Refreshable: ReducerProtocol {
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoading = false
    }
    
    enum Action: Equatable {
        case cancelButtonTapped
        case decrementButtonTapped
        case factResponse(TaskResult<String>)
        case incrementButtonTapped
        case refresh
    }
    
    @Dependency(\.factClient) var factClient
    private enum FactRequestID {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .cancelButtonTapped:
            state.fact = nil
            state.isLoading = false
            return .cancel(id: FactRequestID.self)
            
        case .decrementButtonTapped:
            state.count -= 1
            return .none
            
        case let .factResponse(.success(fact)):
            state.isLoading = false
            state.fact = fact
            return .none
            
        case .factResponse(.failure):
            state.isLoading = false
            return .none
            
        case .incrementButtonTapped:
            state.count += 1
            return .none
            
        case .refresh:
            state.isLoading = true
            state.fact = nil
            return .task { [count = state.count] in
                await .factResponse(TaskResult { try await self.factClient.fetch(count) })
            }
            .animation()
            .cancellable(id: FactRequestID.self)
        }
    }
}

// MARK: - Feature view

struct EffectsRefreshableView: View {
    let store: StoreOf<Refreshable>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List {
                HStack {
                    Button {
                        viewStore.send(.decrementButtonTapped)
                    } label: {
                        Image(systemName: "minus")
                    }
                    
                    Text("\(viewStore.count)")
                        .monospacedDigit()
                    
                    Button {
                        viewStore.send(.incrementButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderless)
                
                if let fact = viewStore.fact {
                    Text(fact)
                        .bold()
                }
                
                if viewStore.isLoading {
                    Button("Cancel") {
                        viewStore.send(.cancelButtonTapped, animation: .default)
                    }
                }
            }
            .refreshable {
                await viewStore.send(.refresh).finish()
            }
        }
    }
}
