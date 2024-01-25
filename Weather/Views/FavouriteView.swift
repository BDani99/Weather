//
//  FavouriteView.swift
//  Weather
//
//  Created by user on 2023. 07. 17..
//

import SwiftUI

struct FavouriteView: View {
    @State private var cityName: String = ""
    @State private var isSheetPresented: Bool = false
    @StateObject private var weatherViewModel = WeatherViewModel()
    @StateObject var forecastViewModel = ForecastViewModel()
    @State private var userData: UserResponse? = nil
    @EnvironmentObject var loginVM: LoginViewModel
    @State private var isTextFieldFocused = false
    @State private var isAdd = false
    @State private var citiesWeatherData: [String: WeatherData] = [:]
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .modifier(DefaultBackground())
                
                if isTextFieldFocused {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            isTextFieldFocused = false
                        }
                }
                
                VStack {
                    if !isTextFieldFocused {
                        Group {
                            fontModifier(text: "Városok keresése!", type: "Montserrat", size: 18, weight: .medium)
                            
                            fontModifier(text: "Fedezze fel az időjárást! Adja meg a város nevét a keresőmezőben, és tájékozódjon azonnal!", type: "Montserrat", size: 18, weight: .light)
                            
                        }
                        .frame(width: containerWidth * 0.88, alignment: .topLeading)
                    }
                    HStack {
                        ZStack {
                            TextField("Város keresés...", text: $cityName, onCommit: {
                                refreshWeatherData()
                                isSheetPresented.toggle()
                            })
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(.white, lineWidth: 2)
                                }
                                .foregroundColor(ColorTheme.textColor)
                                .frame(width: containerWidth * 0.90, height: containerHeight * 0.063)
                                .background(.white)
                                .cornerRadius(30)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .onTapGesture {
                                    isTextFieldFocused = true
                                }
                            
                            Button(action: {
                                refreshWeatherData()
                                isSheetPresented.toggle()
                            }) {
                                Text("\(Image(systemName: "magnifyingglass"))")
                                    .foregroundColor(.black)
                                
                            }
                            .offset(x: 150)
                            .sheet(isPresented: $isSheetPresented) {
                                VStack{
                                    HStack{
                                        Button("Mégsem") {
                                            isSheetPresented = false
                                        }
                                        .padding(.leading)
                                        
                                        Spacer()
                                        
                                        Button("Hozzáadás") {
                                            if let weatherData = weatherViewModel.weatherData {
                                                citiesWeatherData[cityName] = weatherData
                                                isSheetPresented = false
                                                isAdd = false
                                            }
                                        }
                                        .padding(.trailing)
                                    }
                                    .foregroundColor(.black)
                                    .padding(.top)
                                    Spacer()
                                    
                                    VStack {
                                        
                                        if let weatherData = weatherViewModel.weatherData {
                                            WeatherSheetView(cityName: cityName, weatherData: weatherData, forecastViewModel: forecastViewModel)
                                        } else {
                                            Text("No weather data available for \(cityName)")
                                                .padding()
                                        }
                                        
                                    }
                                }
                                .presentationDetents([.height(550)])
                            }
                        }
                    }
                    
                    VStack {
                        ScrollView(showsIndicators: false) {
                            ForEach(citiesWeatherData.sorted(by: { $0.key < $1.key }), id: \.key) { city, weatherData in
                                VStack {
                                    Rectangle()
                                        .foregroundColor(ColorTheme.darkBlue)
                                        .frame(width: containerWidth * 0.95, height: containerHeight * 0.113)
                                        .cornerRadius(30)
                                        .overlay(
                                            ZStack {
                                                HStack {
                                                    
                                                    Spacer()
                                                    
                                                    fontModifierWhite(text: weatherData.temp.roundDouble() + "°", type: "Montserrat", size: 62, weight: .light)
                                                        .kerning(1.24)
                                                    
                                                    Spacer()
                                                    
                                                    
                                                    VStack {
                                                        fontModifierWhite(text: "\(Date.now.formatted())", type: "Montserrat", size: 14, weight: .light)
                                                            .kerning(0.28)
                                                        
                                                        HStack {
                                                            Image(systemName: "location.fill")
                                                                .foregroundColor(.white)
                                                            
                                                            fontModifierWhite(text: capitalizeFirstLetter(word: city), type: "Montserrat", size: 14, weight: .light)
                                                                .kerning(0.28)
                                                        }
                                                        
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    Image("\(weatherData.icon)p")
                                                        .foregroundColor(.white)
                                                    
                                                    Spacer()
                                                    
                                                }
                                                Image("favCities")
                                                    .frame(width: containerWidth * 0.7, height: containerHeight * 0.7)
                                                    .offset(x: 80, y: -13)
                                            }
                                            
                                        )
                                        .padding(.vertical)
                                }
                                
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .onAppear {
                refreshWeatherData()
            }
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func refreshWeatherData() {
        if let token = UserDefaults.standard.string(forKey: "AuthToken") {
            fetchUserData(token: token) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.userData = response
                        self.weatherViewModel.getWeatherData(city: cityName, token: token)
                        self.forecastViewModel.getWeatherForecast(city: cityName, token: token)
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

struct FavouriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteView()
    }
}
