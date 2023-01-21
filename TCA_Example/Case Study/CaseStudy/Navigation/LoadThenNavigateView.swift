//
//  LoadThenNavigateView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/21.
//

import SwiftUI

import ComposableArchitecture

struct LoadThenNavigate: ReducerProtocol {
    struct State: Equatable {
        var optionalCounter: Counter.State?
        var isActivityIndicatorVisable = false
        
        var isNavigationActive: Bool { self.optionalCounter != nil }
    }
    
    enum Action: Equatable {
        case onDisappear
        case optionalCounter(Counter.Action)
        case setNavigation(isActive: Bool)
        case setNavigationISActiveDelayComplted
    }
    
    @Dependency(\.continuousClock) var clock
    private enum CancelID {}
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onDisappear:
                return .cancel(id: CancelID.self)
                
            case .setNavigation(isActive: true):
                state.isActivityIndicatorVisable = true
                return .task {
                    try await self.clock.sleep(for: .seconds(1))
                    return .setNavigationISActiveDelayComplted
                }
                .cancellable(id: CancelID.self)
                
            case .setNavigation(isActive: false):
                state.optionalCounter = nil
                return .none
                
            case .setNavigationISActiveDelayComplted:
                state.isActivityIndicatorVisable = false
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

struct LoadThenNavigateView: View {
    let store: StoreOf<LoadThenNavigate>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                NavigationLink(
                    destination: IfLetStore(
                        self.store.scope(state: \.optionalCounter, action: LoadThenNavigate.Action.optionalCounter),
                        then: {
                            CounterView(store: $0)
                        }
                    ),
                    isActive: viewStore.binding(
                        get: \.isNavigationActive,
                        send: LoadThenNavigate.Action.setNavigation(isActive:)
                    ),
                    label: {
                        HStack {
                            Text("Load Optional counter")
                            if viewStore.isActivityIndicatorVisable {
                                Spacer()
                                ProgressView()
                            }
                        }
                    }
                )
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
        }
    }
}
