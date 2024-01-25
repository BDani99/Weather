//
//  PreView3.swift
//  Weather
//
//  Created by user on 2023. 07. 14..
//

import SwiftUI
import CoreLocationUI

struct PreView3: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var loginVM: LoginViewModel
    @State private var selectedCity = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .overlay(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.24, green: 0.64, blue: 0.8), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.19, green: 0.53, blue: 0.66), location: 1.00),
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
                    
                    imageSize(picture: "CloudSun", pWidht: 2.8, pHeight: 2.8)
                        .padding(.top, 90)
                        .padding(.leading)
                    
                    
                        imageSize(picture: "Page2", pWidht: 0.1, pHeight: 0.1)
                            .padding(.bottom)
                    
                    
                    fontModifier(text: "Megoszthatod a helyzeted", type: "Montserrat", size: 30, weight: .semibold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    
                    fontModifier(text: "Hogy ne érjen semmi\nféle meglepetés.", type: "Montserrat", size: 18, weight: .light)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
             
                    VStack {
                        if loginVM.isAuthenticated || UserDefaults.standard.bool(forKey: "RememberMe"){
                            Button(action: {
                                    if UserDefaults.standard.string(forKey: "AuthToken") != nil {
                                        locationManager.requestLocationPermission()
                                        locationManager.startUpdatingLocation()
                                        locationManager.objectWillChange.send()
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            self.selectedCity = self.locationManager.cityName
                                        }
                                    
                                } else {
                                    print("Authentication token not found.")
                                }
                            }, label: {
                                Image(systemName: "location.fill")
                                Text("Jelenlegi helyzetem megosztása")
                            })
                            .modifier(CustomButtonModifier())
                            
                        } else {
                            
                            preViewButton(destination: RegistrationView())
                            
                        }
                    }
                }
                .padding(.bottom)
                
            }
            
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct PreView3_Previews: PreviewProvider {
    static var previews: some View {
        PreView3()
            .environmentObject(LocationManager())
            .environmentObject(LoginViewModel())
    }
}
