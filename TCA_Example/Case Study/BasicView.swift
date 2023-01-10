//
//  BasicView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/10.
//

import SwiftUI

import ComposableArchitecture

struct CounterReducer: ReducerProtocol {
    struct State: Equatable {
        var count = 0
    }
    
    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
    }
    
    struct Environment {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count += 1
            return .none
        case .incrementButtonTapped:
            state.count -= 1
            return .none
        }
    }
}

struct BasicView: View {
    let store: StoreOf<CounterReducer>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(spacing: 20) {
                Button {
                    viewStore.send(.decrementButtonTapped)
                } label: {
                    Image(systemName: "minus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        
                }
                
                Text("\(viewStore.count)")
                    .font(.largeTitle)
                
                Button {
                    viewStore.send(.incrementButtonTapped)
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                }
            }
        }
    }
}
