//
//  TwoCounters.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/11.
//

import SwiftUI

import ComposableArchitecture

struct TwoCounters: ReducerProtocol {
    struct State: Equatable {
        var counter1 = Counter.State()
        var counter2 = Counter.State()
    }
    
    enum Action: Equatable {
        case counter1(Counter.Action)
        case counter2(Counter.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.counter1, action: /Action.counter1) {
            Counter()
        }
        
        Scope(state: \.counter2, action: /Action.counter2) {
            Counter()
        }
    }
}

struct TwoCountersView: View {
    let store: StoreOf<TwoCounters>
    
    var body: some View {
        VStack {
            CounterView(store: self.store.scope(state: \.counter1, action: TwoCounters.Action.counter1))
            CounterView(store: self.store.scope(state: \.counter2, action: TwoCounters.Action.counter2))
        }
    }
}
