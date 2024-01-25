//
//  WelcomeView.swift
//  Weather
//
//  Created by user on 2023. 07. 14..
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .modifier(DefaultBackground())
            
            VStack(alignment: .center){
                
                Spacer()
                
                Image("Cloud")
                    .resizable()
                    .frame(width: containerWidth * 0.75, height: containerHeight * 0.36)
                
                Text("Weather")
                    .font(
                        Font.custom("Montserrat", size: 50)
                            .weight(.semibold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorTheme.textColor)
                    .frame(width: containerWidth * 0.7, alignment: .top)
                
                Text("Attrecto")
                    .font(Font.custom("Montserrat", size: 30))
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorTheme.textColor.opacity(0.5))
                    .frame(width: containerWidth * 0.4, alignment: .top)
                
                Spacer()
            }
            
        }
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
