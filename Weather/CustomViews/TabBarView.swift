//
//  TabBarView.swift
//
//
//  Created by Attrecto on 2023. 08. 04..
//

import SwiftUI

struct TabBarView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        GeometryReader { geo in
            TabView{
                WeatherView()
                    .tabItem{
                        Image(systemName: "house.fill")
                    }.tag(0)
                FavouriteView()
                    .tabItem{
                        Image(systemName: "star.fill")
                    }.tag(1)
                SettingsView()
                    .tabItem{
                        Image(systemName: "gearshape.fill")
                    }.tag(2)
            }
            .frame(height: geo.size.height * 1.07)
        }
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

