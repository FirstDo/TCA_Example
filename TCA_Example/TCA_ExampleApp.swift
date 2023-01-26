//
//  TCA_ExampleApp.swift
//  TCA_Example
//
//  Created by dudu on 2023/01/10.
//

import SwiftUI

@main
struct TCA_ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Form {
                    NavigationLink("Case Study") {
                        CaseStudyView()
                    }
                    
                    NavigationLink("Search View") {
                        SearchView()
                    }
                }
            }
        }
    }
}
