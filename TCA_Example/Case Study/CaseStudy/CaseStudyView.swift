//
//  CaseStudyView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/10.
//

import SwiftUI

import ComposableArchitecture

struct CaseStudyView: View {
    var body: some View {
        Form {
            Section("GETTING STARTED") {
                NavigationLink("Counter") {
                    CounterView(store: Store(
                        initialState: Counter.State(),
                        reducer: Counter()
                    ))
                }
                
                NavigationLink("Two Counters") {
                    TwoCountersView(store: Store(
                        initialState: TwoCounters.State(),
                        reducer: TwoCounters()
                    ))
                }
                
                NavigationLink("BindingsBasic") {
                    BindingsBasicView(store: Store(
                        initialState: BindingsBasic.State(),
                        reducer: BindingsBasic()
                    ))
                }
                
                NavigationLink("BindingsForm") {
                    BindingsFormView(store: Store(
                        initialState: BindingForm.State(),
                        reducer: BindingForm()
                    ))
                }
                
                NavigationLink("OptionalState") {
                    OptionalStateView(store: Store(
                        initialState: OptionalBasics.State(),
                        reducer: OptionalBasics())
                    )
                }
                
                NavigationLink("SharedState") {
                    SharedStateView(store: Store(
                        initialState: SharedState.State(),
                        reducer: SharedState())
                    )
                }
                
                NavigationLink("AlertConfirmationDialog") {
                    Alert_ConfirmationDialog(store: Store(
                        initialState: AlertAndConfirmationDialog.State(),
                        reducer: AlertAndConfirmationDialog()
                    ))
                }
                
                NavigationLink("FocusDemo") {
                    FocusDemoView(store: Store(
                        initialState: FocusDemo.State(),
                        reducer: FocusDemo()
                    ))
                }
                
                NavigationLink("Animations") {
                    AnimationsView(store: Store(
                        initialState: Animations.State(),
                        reducer: Animations()
                    ))
                }
            }
            
            Section("EFFECTS") {
                NavigationLink("EffectsBasic") {
                    EffectsBasicsView(store: Store(
                        initialState: EffectsBasics.State(),
                        reducer: EffectsBasics()
                    ))
                }
                
                NavigationLink("Effects Cancellation") {
                    EffectsCancellationView(store: Store(
                        initialState: .init(),
                        reducer: EffectsCancellation())
                    )
                }
                
                NavigationLink("Effects LongLiving") {
                    EffectsLongLivingView(store: Store(
                        initialState: .init(),
                        reducer: LongLivingEffects())
                    )
                }
                
                NavigationLink("Effects Refreshable") {
                    EffectsRefreshableView(store: Store(
                        initialState: .init(),
                        reducer: Refreshable())
                    )
                }
            }
            
            Section("NAVIGATION") {
                
            }
            
            Section("HIGHER-ORDER- REDUCERS") {
                
            }
        }
        .navigationTitle("Case Studies")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct CaseStudyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CaseStudyView()
        }
    }
}
