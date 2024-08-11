//
//  SnapCarousleProjectApp.swift
//  SnapCarousleProject
//
//  Created by Siddhatech on 10/08/24.
//

import SwiftUI

@main
struct SnapCarousleProjectApp: App {
    @State private var isActive = false
    var body: some Scene {
        WindowGroup {
            if isActive{
                Home()
            }else{
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.isActive = true
                        }
                    }
            }
        }
    }
}
