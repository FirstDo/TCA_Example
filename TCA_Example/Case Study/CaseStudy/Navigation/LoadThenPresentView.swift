//
//  LoadThenPresent.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/24.
//

import SwiftUI

import ComposableArchitecture

struct LoadThenPresent: ReducerProtocol {
    struct State: Equatable {
        var optionalCounter: Counter.State?
        var isActivityIndicatorVisable = false
        
        var isSheetPresented: Bool { self.optionalCounter != nil }
    }
    
    enum Action {
        case onDisappear
        case optionalCounter(Counter.Action)
        case setSheet(isPresented: Bool)
        case setSheetIsPresentedDelayCompleted
    }
    
    @Dependency(\.continuousClock) var clock
    private enum CancelID {}
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onDisappear:
                return .cancel(id: CancelID.self)
                
            case .optionalCounter:
                return .none
                
            case .setSheet(isPresented: true):
                state.isActivityIndicatorVisable = true
                
                return .task {
                    try await self.clock.sleep(for: .seconds(1))
                    return .setSheetIsPresentedDelayCompleted
                }
                .cancellable(id: CancelID.self)
                
            case .setSheet(isPresented: false):
                state.optionalCounter = nil
                return .none
                
            case .setSheetIsPresentedDelayCompleted:
                state.isActivityIndicatorVisable = false
                state.optionalCounter = Counter.State()
                return .none
            }
        }
        .ifLet(\.optionalCounter, action: /Action.optionalCounter) {
            Counter()
        }
    }
}

struct LoadThenPresentView: View {
    let store: StoreOf<LoadThenPresent>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Button {
                    viewStore.send(.setSheet(isPresented: true))
                } label: {
                    HStack {
                        Text("Load optional counter")
                        if viewStore.isActivityIndicatorVisable {
                            Spacer()
                            ProgressView()
                        }
                    }
                }
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isSheetPresented,
                    send: LoadThenPresent.Action.setSheet(isPresented:)
                )
            ) {
                IfLetStore(
                    self.store.scope(
                        state: \.optionalCounter,
                        action: LoadThenPresent.Action.optionalCounter
                    )
                ) {
                    CounterView(store: $0)
                } else: {
                    ProgressView()
                }
            }
            .navigationTitle("Load and present")
            .onDisappear {
                viewStore.send(.onDisappear)
            }
        }
    }
}
