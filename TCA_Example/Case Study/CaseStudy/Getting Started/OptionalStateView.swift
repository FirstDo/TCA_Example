//
//  OptionalStateView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/12.
//

import SwiftUI

import ComposableArchitecture

struct OptionalBasics: ReducerProtocol {
    struct State: Equatable {
        var optionalCounter: Counter.State?
    }
    
    enum Action: Equatable {
        case optionalCounter(Counter.Action)
        case toggleCounterButtonTapped
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .toggleCounterButtonTapped:
                state.optionalCounter =
                    state.optionalCounter == nil ? Counter.State() : nil
                return .none
            case .optionalCounter:
                return .none
            }
        }
        .ifLet(\.optionalCounter, action: /Action.optionalCounter) {
            Counter()
        }
    }
}

struct OptionalStateView: View {
    let store: StoreOf<OptionalBasics>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Button("Toggle counter") {
                    viewStore.send(.toggleCounterButtonTapped)
                }
                
                IfLetStore(
                    self.store.scope(state: \.optionalCounter, action: OptionalBasics.Action.optionalCounter),
                    then: { store in
                        Text("CounterState is non - nil")
                        CounterView(store: store)
                            .buttonStyle(.borderless)
                            .frame(maxWidth: .infinity)
                    },
                    else: {
                        Text("CounterState is nil")
                    }
                )
            }
        }
        
    }
}
