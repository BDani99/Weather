//
//  SettingsView.swift
//  Weather
//
//  Created by user on 2023. 07. 13..
//

import SwiftUI

struct SettingsView: View {
    @State private var name = ""
    @State private var userData: UserResponse? = nil
    @State private var unityOfMeasure = ""
    @State private var cityName = ""
    @AppStorage("showCity") private var showCity = false
    @EnvironmentObject var loginVM: LoginViewModel
    @StateObject private var updateUM = UpdateUserManager()
    @EnvironmentObject var location: LocationManager
    
    var tempType = ["Celsius", "Fahrenheit"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .modifier(DefaultBackground())
                
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        fontModifier(text: "Beállítások", type: "Montserrat", size: 18, weight: .medium)
                        
                        fontModifier(text: "Ezekkel személyre szabhatod az alkalmazás \nhasználatát!", type: "Montserrat", size: 16, weight: .light)
                    }
                    .padding(.trailing)
                    .padding()
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        fontModifier(text: "Név megváltoztatása", type: "Montserrat", size: 16, weight: .light)
                        
                        HStack {
                            Image(systemName: "person.fill")
                            TextField(userData?.username ?? "", text: $name)
                        }
                        .modifier(SettingsTextModifier())
                        
                        
                        fontModifier(text: "Helyzet megosztásának engedélyezése", type: "Montserrat", size: 16, weight: .light)
                        
                        Toggle("Helymeghatározás", isOn: $showCity)
                            .modifier(CustomTextModifier())
                            .onChange(of: showCity) { newValue in
                                UserDefaults.standard.set(newValue, forKey: "showCity")
                            }
                        
                        
                        fontModifier(text: "Hőmérséklet mértékegység választása\n(Celsius / Fahrenheit)" , type: "Montserrat", size: 16, weight: .light)
                        HStack {
                            Text("Mértékegység")
                            
                            Spacer()
                            
                            Picker("", selection: $unityOfMeasure) {
                                ForEach(tempType, id: \.self) {
                                    Text($0)
                                }
                            }
                            .frame(width: containerWidth * 0.4, height: containerHeight * 0.2)
                            .pickerStyle(.segmented)
                        }
                        .modifier(CustomTextModifier())
                        
                        fontModifier(text: "Alapértelmezett város megadása" , type: "Montserrat", size: 16, weight: .light)
                        
                        HStack {
                            Image(systemName: "house.and.flag")
                            TextField(showCity ? userData?.city ?? "Alapértelmezett város megadása" : "Adja meg az alapértelmezett várost", text: $cityName)
                        }
                        .modifier(SettingsTextModifier())
                        .disabled(showCity)
                        
                        Spacer()
                        VStack(spacing: 20) {
                            Button {
                                getUserData()
                            } label: {
                                fontModifier(text: "Mentés", type: "Montserrat", size: 20, weight: .medium)
                            }
                            .modifier(SettingsButtonModifier())
                            
                            
                            Button {
                                loginVM.signout()
                            }label: {
                                Text("Kijelentkezés")
                                    .font(
                                        Font.custom("Montserrat", size: 20)
                                            .weight(.medium)
                                    )
                                    .foregroundColor(.white)
                                
                            }
                            .font(.title3)
                            
                            .frame(width: containerWidth * 0.925, height: containerHeight * 0.063)
                            .background(ColorTheme.lightRed)
                            .cornerRadius(30)
                            .padding(.bottom, 90)
                        }
                    }
                    
                    Spacer()
                    
                    
                    
                    
                }
                .ignoresSafeArea(edges: .bottom)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if let token = UserDefaults.standard.string(forKey: "AuthToken") {
                fetchUserData(token: token) { result in
                    switch result {
                    case .success(let response):
                        DispatchQueue.main.async {
                            self.userData = response
                            self.name = capitalizeFirstLetter(word: response.username)
                            self.cityName = capitalizeFirstLetter(word: response.city)
                            self.unityOfMeasure = response.unitOfMeasure 
                            self.showCity = UserDefaults.standard.bool(forKey: "showCity")
                        }
                    case .failure(let error):
                        print("Failed to fetch user data: \(error)")
                    }
                }
            } else {
                print("Authentication token not found.")
            }
        }
    }
    
    func getUserData() {
            loginVM.accessToken = UserDefaults.standard.string(forKey: "AuthToken") ?? ""
            let userData = UpdateUserData(username: name, unitOfMeasure: unityOfMeasure, city: cityName, defaultPage: "Current")
            updateUM.updateUser(userData: userData, token: loginVM.accessToken) { result in
                switch result {
                case .success:
                    print("Settings updated successfully!")
                    print("token: \(loginVM.accessToken)")
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(LoginViewModel())
    }
}
