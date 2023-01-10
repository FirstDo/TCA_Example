//
//  ContentView.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Form {
            NavigationLink("Case Study") {
                CaseStudyView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
