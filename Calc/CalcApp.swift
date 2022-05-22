//
//  CalcApp.swift
//  Calc
//
//  Created by TRkizaki on 22/5/2022.
//

import SwiftUI

@main
struct CalcApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Calculator()
                    .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
          
        }
    }
}
