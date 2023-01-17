//
//  EffectsBasicsView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/17.
//

import SwiftUI

import ComposableArchitecture

struct EffectsBasics: ReducerProtocol {
    struct State: Equatable {
        var count = 0
        var isNumberFactRequestInFlight = false
        var numberFact: String?
    }
    
    enum Action: Equatable {
        case decrementButtonTapped
        case decrementDelayResponse
        case incrementButtonTapped
        case numberFactButtonTapped
        case numberFactResponse(TaskResult<String>)
    }
    
    @Dependency(\.continuousClock) var closk
    @Dependency(\.factClient) var factClient
    private enum DelayID {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            state.numberFact = nil
            
            return state.count >= 0
            ? .none
            : .task {
                try await self.closk.sleep(for: .seconds(1))
                return .decrementDelayResponse
            }
            .cancellable(id: DelayID.self)
        
        case .decrementDelayResponse:
            if state.count < 0 {
                state.count += 1
            }
            
            return .none
            
        case .incrementButtonTapped:
            state.count += 1
            state.numberFact = nil
            return state.count >= 0 ? .cancel(id: DelayID.self) : .none
            
        case .numberFactButtonTapped:
            state.isNumberFactRequestInFlight = true
            state.numberFact = nil
            
            return .task { [count = state.count ] in
                await .numberFactResponse(
                    TaskResult {
                        try await self.factClient.fetch(count)
                    }
                )
            }
        case let .numberFactResponse(.success(response)):
            state.isNumberFactRequestInFlight = false
            state.numberFact = response
            return .none
        case .numberFactResponse(.failure):
            state.isNumberFactRequestInFlight = false
            return .none
        }
    }
}

struct EffectsBasicsView: View {
    let store: StoreOf<EffectsBasics>
    @Environment(\.openURL) var openURL
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    HStack {
                        Button {
                            viewStore.send(.decrementButtonTapped)
                        } label: {
                            Image(systemName: "minus")
                        }
                        
                        Text("\(viewStore.count)")
                            .monospacedDigit()
                        
                        Button {
                            viewStore.send(.incrementButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button("Number fact") {
                        viewStore.send(.numberFactButtonTapped)
                    }
                    .frame(maxWidth: .infinity)
                    
                    if viewStore.isNumberFactRequestInFlight {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .id(UUID())
                    }
                    
                    if let numberFact = viewStore.numberFact {
                        Text(numberFact)
                    }
                }
                
                Section {
                    Button("Number facts provied by numbersapi.com") {
                        self.openURL(URL(string: "http://numbersapi.com")!)
                    }
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderless)
        }
        .navigationTitle("Effects")
    }
}
