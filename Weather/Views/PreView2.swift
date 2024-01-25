//
//  PreView2.swift
//  Weather
//
//  Created by user on 2023. 07. 14..
//

import SwiftUI

struct PreView2: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .overlay(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.45, green: 0.75, blue: 0.27), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.3, green: 0.41, blue: 0.08), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.05, y: 0),
                            endPoint: UnitPoint(x: 0.05, y: 0.9)
                        )
                        .edgesIgnoringSafeArea(.all)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 583)
                            .frame(width: 583, height: 583)
                            .foregroundColor(.white)
                            .padding(.top, 580)
                    )
                
                VStack(alignment: .center) {
                
                    VStack {
                        imageSize(picture: "Sun", pWidht: 2.8, pHeight: 2.8)
                            .padding(.top, 90)
                            .padding(.leading)
                        
                        imageSize(picture: "Page2", pWidht: 0.1, pHeight: 0.1)
                            .padding(.bottom, 60)
                           
                    }
        
                    VStack {
                        fontModifier(text: "Időjárás a világ körül", type: "Montserrat", size: 30, weight: .semibold)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                        
                        fontModifier(text: "Adjon hozzá tetszőleges\n helyszínt.", type: "Montserrat", size: 18, weight: .light)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                    }
                   
                    VStack {
                        preViewButton(destination: PreView3())
                        .padding(.bottom)
                        
                    }
                   
                    
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct PreView2_Previews: PreviewProvider {
    static var previews: some View {
        PreView2()
    }
}
