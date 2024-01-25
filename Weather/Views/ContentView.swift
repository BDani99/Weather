//
//  ContentView.swift
//  Weather
//
//  Created by user on 2023. 07. 13..
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var loginVM: LoginViewModel
    @State private var showWelcomeView = true
    @State private var delay = 2.0
    
    var body: some View {
        Group {
            if showWelcomeView {
                WelcomeView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            withAnimation {
                                showWelcomeView = false
                            }
                        }
                    }
            } else {
                if UserDefaults.standard.bool(forKey: "RememberMe") {
                    if locationManager.cityName == "" {
                        PreView3()
                    } else {
                        TabBarView()
                    }
                } else {
                    if loginVM.isAuthenticated == false {
                        LoginView()
                    } else {
                        if locationManager.cityName == "" {
                            PreView3()
                        } else {
                            TabBarView()
                        }
                    }
                }
            }
        
        }
        
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LoginViewModel())
    }
}

