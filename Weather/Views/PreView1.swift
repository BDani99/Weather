//
//  PreView1.swift
//  Weather
//
//  Created by user on 2023. 07. 14..
//

import SwiftUI

struct PreView1: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .overlay(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: ColorTheme.darkBlue, location: 0.00),
                                Gradient.Stop(color: Color(red: 0.17, green: 0.18, blue: 0.21), location: 1.00),
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
                    imageSize(picture: "Night", pWidht: 3.8, pHeight: 2.8)
                        .padding(.top, 90)
                        .padding(.leading)
                    
                    imageSize(picture: "Page1", pWidht: 0.1, pHeight: 0.1)
                        .padding(.bottom)
                        .padding(.bottom)
                    
                    fontModifier(text: "Részletes óránkénti \n előrejelzés", type: "Montserrat", size: 30, weight: .semibold)
                        .multilineTextAlignment(.center)
                    
                    fontModifier(text: "Kapj részletes időjárási\ninformációkat.", type: "Montserrat", size: 18, weight: .light)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    
                    
                    preViewButton(destination: PreView2())
                        .padding(.bottom)
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct PreView1_Previews: PreviewProvider {
    static var previews: some View {
        PreView1()
    }
}
