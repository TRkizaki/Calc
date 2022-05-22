//
//  CalcApp.swift
//  Calc
//
//  Created by DJ perrier  on 18/5/2022.
//

import SwiftUI

@main
struct CalcApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
          
        }
    }
}
