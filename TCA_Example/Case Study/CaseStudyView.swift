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
                NavigationLink("Basic") {
                    BasicView(store: Store(
                        initialState: CounterReducer.State(),
                        reducer: CounterReducer()
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
