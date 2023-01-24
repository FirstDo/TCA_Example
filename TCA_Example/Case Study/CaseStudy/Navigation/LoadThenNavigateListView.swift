//
//  LoadThenNavigateListView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/24.
//

import SwiftUI

import ComposableArchitecture

struct LoadThenNavigateList: ReducerProtocol {
    struct State: Equatable {
        var rows: IdentifiedArrayOf<Row> = [
            Row(count: 1, id: UUID()),
            Row(count: 42, id: UUID()),
            Row(count: 100, id: UUID()),
        ]
        
        var selection: Identified<Row.ID, Counter.State>?
        
        struct Row: Equatable, Identifiable {
            var count: Int
            let id: UUID
            var isActivityIndicatorVisable = false
        }
    }
    
    enum Action: Equatable {
        case onDisappear
        case counter(Counter.Action)
        case setNavigation(selection: UUID?)
        case setNavigationSelectiondelayComplted(UUID)
    }
    
    @Dependency(\.continuousClock) var clock
    private enum CancelID {}
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onDisappear:
                return .cancel(id: CancelID.self)
                
            case .counter:
                return .none
                
            case let .setNavigation(selection: .some(id)):
                for row in state.rows {
                    state.rows[id: row.id]?.isActivityIndicatorVisable = row.id == id
                }
                return .task {
                    try await self.clock.sleep(for: .seconds(1))
                    return .setNavigationSelectiondelayComplted(id)
                }
                .cancellable(id: CancelID.self, cancelInFlight: true)
                
            case .setNavigation(selection: .none):
                if let selection = state.selection {
                    state.rows[id: selection.id]?.count = selection.count
                }
                state.selection = nil
                return .cancel(id: CancelID.self)
                
            case let .setNavigationSelectiondelayComplted(id):
                state.rows[id: id]?.isActivityIndicatorVisable = false
                state.selection = Identified(
                    Counter.State(count: state.rows[id: id]?.count ?? 0),
                    id: id
                )
                return .none
            }
        }
        .ifLet(\.selection, action: /Action.counter) {
            Scope(state: \.value, action: /.self) {
                Counter()
            }
        }
    }
}

struct LoadThenNavigateListView: View {
    let store: StoreOf<LoadThenNavigateList>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                ForEach(viewStore.rows) { row in
                    NavigationLink(
                        destination: IfLetStore(
                            self.store.scope(
                                state: \.selection?.value,
                                action: LoadThenNavigateList.Action.counter
                            )
                        ) {
                            CounterView(store: $0)
                        },
                        tag: row.id,
                        selection: viewStore.binding(
                            get: \.selection?.id,
                            send: LoadThenNavigateList.Action.setNavigation(selection:)
                        )
                    ) {
                        HStack {
                            Text("load optional counter that starts from \(row.count)")
                            
                            if row.isActivityIndicatorVisable {
                                Spacer()
                                ProgressView()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Load then navigate")
            .onDisappear { viewStore.send(.onDisappear) }
        }
    }
}
