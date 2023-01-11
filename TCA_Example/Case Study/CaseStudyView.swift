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
