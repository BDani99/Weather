//
//  Modifiers.swift
//  Weather
//
//  Created by user on 2023. 07. 14..
//

import Foundation
import SwiftUI

var containerWidth: CGFloat = UIScreen.main.bounds.width
var containerHeight: CGFloat = UIScreen.main.bounds.height

struct CustomButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
                content
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: containerWidth * 0.90, height: containerHeight * 0.063)
                    .background(ColorTheme.darkBlue)
                    .cornerRadius(30)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color(red: 0.17, green: 0.16, blue: 0.66), Color(red: 0.96, green: 0.44, blue: 0.43)]), startPoint: .top, endPoint: .bottom), lineWidth: 4)
                    )
    }
}


struct SettingsButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(ColorTheme.darkBlue)
            .frame(width: containerWidth * 0.90, height: containerHeight * 0.063)
            .background(.white)
            .cornerRadius(30)
            .font(.title3)
    }
}


struct CustomTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.white, lineWidth: 2)
            }
            .foregroundColor(ColorTheme.textColor)
            .frame(width: containerWidth * 0.925, height: containerHeight * 0.063)
            .background(.white)
            .cornerRadius(30)
            .autocapitalization(.none)
            .disableAutocorrection(true)
        
    }
}


struct SettingsTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.white, lineWidth: 2)
            }
            .foregroundColor(ColorTheme.textColor)
            .frame(width: containerWidth * 0.925, height: containerHeight * 0.063)
            .background(.white)
            .cornerRadius(30)
            .autocapitalization(.none)
            .disableAutocorrection(true)
        
    }
}


struct CustomHeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(
                Font.custom("Montserrat", size: 24)
                    .weight(.medium)
            )
            .multilineTextAlignment(.center)
            .foregroundColor(ColorTheme.textColor)
        
    }
}


func customTextField(text: String, picture: String, username: Binding<String>) -> some View {
    HStack {
        Image(systemName: picture)
        TextField("\(text)", text: username)
    }
    .padding()
    .overlay {
        RoundedRectangle(cornerRadius: 30)
            .stroke(.white, lineWidth: 2)
    }
    .foregroundColor(ColorTheme.textColor)
    .frame(width: containerWidth * 0.925, height: containerHeight * 0.063)
    .background(.white)
    .cornerRadius(30)
    .autocapitalization(.none)
    .disableAutocorrection(true)
    .padding()
}


struct DefaultBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.clear)
            .background(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.95, green: 0.96, blue: 0.97), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.74, green: 0.78, blue: 0.84), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.25, y: -0.33),
                    endPoint: UnitPoint(x: -0.83, y: 0.69)
                )
            )
    }
}


func customSecureField(text: String, picture: String, username: Binding<String>) -> some View {
    HStack {
        Image(systemName: picture)
        SecureField("\(text)", text: username)
    }
    .padding()
    .overlay {
        RoundedRectangle(cornerRadius: 30)
            .stroke(.white, lineWidth: 2)
    }
    .foregroundColor(ColorTheme.textColor)
    .frame(width: containerWidth * 0.925, height: containerHeight * 0.063)
    .background(.white)
    .cornerRadius(30)
    .autocapitalization(.none)
    .disableAutocorrection(true)
}


func fontModifier(text: String, type: String, size: CGFloat, weight: Font.Weight) -> some View {
    Text(text)
        .font(
            Font.custom(type, size: size)
                .weight(weight)
        )
        .foregroundColor(ColorTheme.textColor)
        .padding(1)
}


func fontModifierWhite(text: String, type: String, size: CGFloat, weight: Font.Weight) -> some View {
    Text(text)
        .font(
            Font.custom(type, size: size)
                .weight(weight)
        )
        .foregroundColor(.white)
        .padding(1)
}


func buttonFontModifier(text: String, type: String, size: CGFloat, weight: Font.Weight) -> some View {
    Text(text)
        .font(
            Font.custom(type, size: size)
                .weight(weight)
        )
}


struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        
        Button(action: {
            configuration.isOn.toggle()
            
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .resizable()
                configuration.label
            }
        })
        .foregroundColor(ColorTheme.textColor)
    }
}

func capitalizeFirstLetter(word: String) -> String {
    guard let firstLetter = word.first else { return word }
    return word.replacingCharacters(in: word.startIndex...word.startIndex, with: String(firstLetter).capitalized)
}


func imageSize(picture: String, pWidht: Double, pHeight: Double) -> some View {
    
    GeometryReader { geo in
        Image(picture)
            .resizable()
            .scaledToFit()
            .clipped()
            .frame(width: geo.size.width * pWidht, height: geo.size.height * pHeight)
            .frame(width: geo.size.width, height: geo.size.height)
    }
}

func preViewButton(destination: some View) -> some View {
    Button {
        
    } label: {
        NavigationLink(destination: destination) {
            ZStack {
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 53, height: 53)
                    .background(ColorTheme.darkBlue)
                    .cornerRadius(53)
                
                Image(systemName: "arrow.right")
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 80, height: 80)
                    .cornerRadius(80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 80)
                            .inset(by: 0.5)
                            .stroke(ColorTheme.darkBlue, lineWidth: 1)
                    )
                
            }
        }
    }
}
