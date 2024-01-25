//
//  CustomTabView.swift
//  Weather
//
//  Created by user on 2023. 07. 27..
//

import Foundation
import SwiftUI

struct CustomTabView: View {
    @State var house: String
    @State var star: String
    @State var gear: String
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(ColorTheme.darkBlue)
                .frame(width: 428, height: 81)
                .cornerRadius(60)
                .overlay(
                    
                    HStack {
                        
                        Spacer()
                        
                        Button {
                        } label: {
                            NavigationLink(destination: ContentView()) {
                                Image(systemName: house)
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        
                        Button {
                        } label: {
                            NavigationLink(destination: FavouriteView()) {
                                Image(systemName: star)
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                        } label: {
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: gear)
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                    }
                )
        }
    }
}
