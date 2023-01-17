//
//  FocusDemoView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/17.
//

import SwiftUI

import ComposableArchitecture

struct FocusDemo: ReducerProtocol {
    struct State: Equatable {
        @BindableState var focusedField: Field?
        @BindableState var password: String = ""
        @BindableState var username: String = ""
        
        enum Field: String, Hashable {
            case username, password
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case signInButtonTapped
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .signInButtonTapped:
                if state.username.isEmpty {
                    state.focusedField = .username
                } else if state.password.isEmpty {
                    state.focusedField = .password
                }
                
                return .none
            }
        }
    }
}

struct FocusDemoView: View {
    let store: StoreOf<FocusDemo>
    @FocusState var focusedField: FocusDemo.State.Field?
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                VStack {
                    TextField("Username", text: viewStore.binding(\.$username))
                        .focused($focusedField, equals: .username)
                    SecureField("Password", text: viewStore.binding(\.$password))
                        .focused($focusedField, equals: .password)
                    Button("Sign In") {
                        viewStore.send(.signInButtonTapped)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .textFieldStyle(.roundedBorder)
                .onChange(of: viewStore.focusedField) { focusedField = $0 }
                .onChange(of: focusedField) { viewStore.send(.set(\.$focusedField, $0)) }
                //.synchronize(viewStore.binding(\.$focusedField), self.$focusedField)
            }
        }
        .navigationTitle("Focus demo")
    }
}

extension View {
    func synchronize<Value>(
        _ first: Binding<Value>,
        _ second: FocusState<Value>.Binding
    ) -> some View {
        self
            .onChange(of: first.wrappedValue) { second.wrappedValue = $0 }
            .onChange(of: second.wrappedValue) { first.wrappedValue = $0 }
    }
}
