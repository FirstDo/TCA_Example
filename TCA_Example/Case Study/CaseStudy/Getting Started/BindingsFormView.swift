//
//  BindingsFormView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/11.
//

import SwiftUI

import ComposableArchitecture

struct BindingForm: ReducerProtocol {
    struct State: Equatable {
        @BindableState var sliderValue = 5.0
        @BindableState var stepCount = 10
        @BindableState var text = ""
        @BindableState var toggleIsOn = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case resetButtonTapped
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$stepCount):
                state.sliderValue = .minimum(state.sliderValue, Double(state.stepCount))
                return .none
            case .binding:
                return .none
            case .resetButtonTapped:
                state = State()
                return .none
            }
        }
    }
}

struct BindingsFormView: View {
    let store: StoreOf<BindingForm>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                TextField(
                    "Type here",
                    text: viewStore.binding(\.$text)
                )
                    .foregroundStyle(viewStore.toggleIsOn ? .secondary : .primary)
                    .disabled(viewStore.toggleIsOn)
                
                Toggle(
                    "Disable other controls",
                    isOn: viewStore.binding(\.$toggleIsOn)
                )
                
                Stepper(
                  "Max slider value: \(viewStore.stepCount)",
                  value: viewStore.binding(\.$stepCount),
                  in: 0...100
                )
                .disabled(viewStore.toggleIsOn)
                
                HStack {
                  Text("Slider value: \(Int(viewStore.sliderValue))")

                  Slider(value: viewStore.binding(\.$sliderValue), in: 0...Double(viewStore.stepCount))
                    .tint(.accentColor)
                }
                .disabled(viewStore.toggleIsOn)

                Button("Reset") {
                  viewStore.send(.resetButtonTapped)
                }
                .tint(.red)
            }
        }
    }
}
