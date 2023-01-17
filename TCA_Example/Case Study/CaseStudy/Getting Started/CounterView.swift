//
//  CounterView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/10.
//

import SwiftUI

import ComposableArchitecture

struct Counter: ReducerProtocol {
    struct State: Equatable {
        var count = 0
    }
    
    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
    }
    
    struct Environment {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            return .none
        case .incrementButtonTapped:
            state.count += 1
            return .none
        }
    }
}

struct CounterView: View {
    let store: StoreOf<Counter>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
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
        }
    }
}
