//
//  BindingsBasicView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/11.
//

import SwiftUI

import ComposableArchitecture

struct BindingsBasic: ReducerProtocol {
    struct State: Equatable {
        var sliderValue = 5.0
        var stepCount = 10
        var text = ""
        var toggleIsOn = false
    }
    
    enum Action {
        case sliderValueChanged(Double)
        case stepCountChanged(Int)
        case textChanged(String)
        case toggleChanged(isOn: Bool)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .sliderValueChanged(let value):
            state.sliderValue = value
            return .none
        case .stepCountChanged(let value):
            state.sliderValue = .minimum(state.sliderValue, Double(value))
            state.stepCount = value
            return .none
        case .textChanged(let text):
            state.text = text
            return .none
        case .toggleChanged(let isOn):
            state.toggleIsOn = isOn
            return .none
        }
    }
}

struct BindingsBasicView: View {
    let store: StoreOf<BindingsBasic>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                TextField(
                    "Type here",
                    text: viewStore.binding(get: \.text, send: BindingsBasic.Action.textChanged)
                )
                .autocorrectionDisabled()
                .foregroundColor(viewStore.toggleIsOn ? Color.secondary : .primary)
                .disabled(viewStore.toggleIsOn)
                
                Toggle(
                    "Disable other controls",
                    isOn: viewStore.binding(get: \.toggleIsOn, send: BindingsBasic.Action.toggleChanged)
                )
                
                Stepper(
                    "Max slider value: \(viewStore.stepCount)",
                    value: viewStore.binding(get: \.stepCount, send: BindingsBasic.Action.stepCountChanged),
                    in: 0...100
                )
                .disabled(viewStore.toggleIsOn)
                
                HStack {
                    Text("Value: \(Int(viewStore.sliderValue))")
                    
                    Slider(
                        value: viewStore.binding(get: \.sliderValue, send: BindingsBasic.Action.sliderValueChanged),
                        in: 0...Double(viewStore.stepCount),
                        step: 1
                    )
                    .disabled(viewStore.toggleIsOn)
                }
            }
        }
    }
}

struct BindingsBasicView_Previews: PreviewProvider {
    static var previews: some View {
        BindingsBasicView(store: Store(initialState: BindingsBasic.State(), reducer: BindingsBasic()))
    }
}
