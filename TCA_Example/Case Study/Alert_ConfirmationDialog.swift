//
//  Alert_ConfirmationDialog.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/16.
//

import SwiftUI

import ComposableArchitecture

struct AlertAndConfirmationDialog: ReducerProtocol {
    struct State: Equatable {
        var alert: AlertState<Action>?
        var confirmationDialog: ConfirmationDialogState<Action>?
        var count = 0
    }
    
    enum Action: Equatable {
        case alertButtonTapped
        case alertDismissed
        case confirmationDialogButtonTapped
        case confirmationDialogDismissed
        case decrementButtonTapped
        case incrementButtonTapped
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .alertButtonTapped:
            state.alert = AlertState {
                TextState("Alert!")
            } actions: {
                ButtonState(role: .cancel) {
                    TextState("Cancel")
                }
                ButtonState(action: .incrementButtonTapped) {
                    TextState("Increment")
                }
            } message: {
                TextState("This is an alert")
            }
            return .none
            
        case .alertDismissed:
            state.alert = nil
            return .none
            
        case .confirmationDialogButtonTapped:
            state.confirmationDialog = ConfirmationDialogState {
                TextState("Confirmation dialog")
            } actions: {
                ButtonState(role: .cancel) {
                    TextState("Cancel")
                }
                ButtonState(action: .incrementButtonTapped) {
                    TextState("Increment")
                }
                ButtonState(action: .decrementButtonTapped) {
                    TextState("Decrement")
                }
            } message: {
                TextState("This is a confirmation dialog.")
            }
            return .none
            
        case .confirmationDialogDismissed:
            state.confirmationDialog = nil
            return .none
            
        case .decrementButtonTapped:
            state.alert = AlertState { TextState("Decremented!") }
            state.count -= 1
            return .none
            
        case .incrementButtonTapped:
            state.alert = AlertState { TextState("Incremented!") }
            state.count += 1
            return .none
        }
    }
}

struct Alert_ConfirmationDialog: View {
    let store: StoreOf<AlertAndConfirmationDialog>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Text("Count: \(viewStore.count)")
                Button("Alert") {
                    viewStore.send(.alertButtonTapped)
                }
                Button("Confirmation Dialog") {
                    viewStore.send(.confirmationDialogButtonTapped)
                }
            }
            .navigationTitle("Alerts & Dialogs")
            .alert(
                self.store.scope(state: \.alert),
                dismiss: .alertDismissed
            )
            .confirmationDialog(
                self.store.scope(state: \.confirmationDialog),
                dismiss: .confirmationDialogDismissed
            )
        }
    }
}
