//
//  PresentAndLoadView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/24.
//

import SwiftUI

import ComposableArchitecture

struct PresentAndLoad: ReducerProtocol {
    struct State: Equatable {
        var counter: Counter.State?
        var isSheetPresented = false
    }
    
    enum Action {
        case counter(Counter.Action)
        case setSheet(isPresented: Bool)
        case setSheetIsPresentedDelayCompleted
    }
    
    @Dependency(\.continuousClock) var clock
    private enum CancelID {}
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .setSheet(isPresented: true):
                state.isSheetPresented = true
                return .task {
                    try await self.clock.sleep(for: .seconds(1))
                    return .setSheetIsPresentedDelayCompleted
                }
                .cancellable(id: CancelID.self)
                
            case .setSheet(isPresented: false):
                state.isSheetPresented = false
                state.counter = nil
                return .cancel(id: CancelID.self)
                
            case .setSheetIsPresentedDelayCompleted:
                state.counter = Counter.State()
                return .none
                
            case .counter:
                return .none
            }
        }
        .ifLet(\.counter, action: /Action.counter) {
            Counter()
        }
    }
}

struct PresentAndLoadView: View {
    let store: StoreOf<PresentAndLoad>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Button("load optional counter") {
                    viewStore.send(.setSheet(isPresented: true))
                }
            }
            .sheet(isPresented: viewStore.binding(
                get: \.isSheetPresented,
                send: PresentAndLoad.Action.setSheet(isPresented:)
            )) {
                IfLetStore(
                    self.store.scope(
                        state: \.counter,
                        action: PresentAndLoad.Action.counter)
                ) {
                    CounterView(store: $0)
                } else: {
                    ProgressView()
                }
            }
            .navigationTitle("Present and load")
        }
    }
}
