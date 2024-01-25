//
//  WeatherApp.swift
//  Weather
//
//  Created by user on 2023. 07. 13..
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(LoginViewModel())
                .environmentObject(LocationManager())
                .environmentObject(RegistrationViewModel())
                
        }
    }
}
