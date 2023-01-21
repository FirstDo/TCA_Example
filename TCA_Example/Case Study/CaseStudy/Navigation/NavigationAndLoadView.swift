//
//  NavigationAndLoadView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/21.
//

import SwiftUI

import ComposableArchitecture

struct NavigationAndLoad: ReducerProtocol {
    struct State: Equatable {
        var isNavigationActive = false
        var optionalCounter: Counter.State?
    }
    
    enum Action: Equatable {
        case optionalCounter(Counter.Action)
        case setNavigation(isActive: Bool)
        case setNavigationIsActiveDelayCompleted
    }
    
    @Dependency(\.continuousClock) var clock
    private enum CancelID {}
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .setNavigation(isActive: true):
                state.isNavigationActive = true
                return .task {
                    try await self.clock.sleep(for: .seconds(1))
                    return .setNavigationIsActiveDelayCompleted
                }
                .cancellable(id: CancelID.self)
            case .setNavigation(isActive: false):
                state.isNavigationActive = false
                state.optionalCounter = nil
                return .cancel(id: CancelID.self)
            case .setNavigationIsActiveDelayCompleted:
                state.optionalCounter = Counter.State()
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

struct NavigationAndLoadView: View {
    let store: StoreOf<NavigationAndLoad>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                NavigationLink(
                    destination: IfLetStore(
                        self.store.scope(
                            state: \.optionalCounter,
                            action: NavigationAndLoad.Action.optionalCounter
                        )
                    ) {
                        CounterView(store: $0)
                    } else: {
                        ProgressView()
                    },
                    isActive: viewStore.binding(get: \.isNavigationActive, send: NavigationAndLoad.Action.setNavigation(isActive:)),
                    label: {
                        Text("Load optional counter")
                    }
                )
            }
        }
        .navigationTitle("Navigate and load")
    }
}
