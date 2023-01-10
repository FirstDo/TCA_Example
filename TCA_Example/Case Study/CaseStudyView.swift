//
//  CaseStudyView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/10.
//

import SwiftUI

struct CaseStudyView: View {
    var body: some View {
        Form {
            Section("GETTING STARTED") {
                NavigationLink("Basic") {
                    BasicView()
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
