//
//  EffectsLongLivingView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/18.
//

import SwiftUI

import ComposableArchitecture

struct LongLivingEffects: ReducerProtocol {
    struct State: Equatable {
        var screenshotCount = 0
    }
    
    enum Action: Equatable {
        case task
        case userDidTakeScreenshotNotification
    }
    
    @Dependency(\.screenshots) var screenshots
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .task:
            return .run { send in
                for await _ in await self.screenshots() {
                    await send(.userDidTakeScreenshotNotification)
                }
            }
        case .userDidTakeScreenshotNotification:
            state.screenshotCount += 1
            return .none
        }
    }
}

struct EffectsLongLivingView: View {
    let store: StoreOf<LongLivingEffects>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    Text("A screenshot of this screen has been taken \(viewStore.screenshotCount) times.")
                        .font(.headline)
                }
                
                Section {
                    NavigationLink("Navigate to another screen") {
                        Text("Try Screen Shot!")
                    }
                }
            }
            .task {
                await viewStore.send(.task).finish()
            }
        }
        .navigationTitle("Long-living effects")
    }
}
