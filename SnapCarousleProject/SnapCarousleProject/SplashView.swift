//
//  SplashView.swift
//  MovieSelectionApp
//
//  Created by Siddhatech on 08/08/24.
//

import SwiftUI

struct SplashView: View {
    @State private var size = 0.5
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack {
            Color("Blue").opacity(3)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaleEffect(size)
                    .opacity(opacity)
                    .animation(.easeInOut(duration: 1.5))
                
                Text("Welcome\nTo Daily Needs")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .italic()
                    .font(.system(size: 60))
            }.padding(.bottom,120)
            .onAppear {
                withAnimation {
                    self.size = 1.5
                    self.opacity = 1
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
