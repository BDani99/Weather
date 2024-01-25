//
//  WeatherView.swift
//  Weather
//
//  Created by user on 2023. 07. 14..
//
import SwiftUI


struct WeatherView: View {
    @StateObject var weatherViewModel = WeatherViewModel()
    @StateObject var forecastViewModel = ForecastViewModel()
    @State private var userData: UserResponse? = nil
    @State private var city = ""
    @State private var isShowingWeeklyForecast = false
    @State private var selectedForecast: [ForecastData]?
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        NavigationView {
            if weatherViewModel.weatherData != nil {
                if forecastViewModel.forecastData != nil{
                    ZStack {
                        Rectangle()
                            .modifier(DefaultBackground())
                        
                        VStack {
                            
                            VStack {
                                
                                VStack(alignment: .leading) {
                                    Group {
                                        fontModifier(text: "Üdv \(capitalizeFirstLetter(word: userData?.username ?? "Felhasználó"))!", type: "Montserrat", size: 18, weight: .medium)
                                        
                                        fontModifier(text: "Fedezze fel az időjárást!", type: "Montserrat", size: 16, weight: .light)
                                    }
                                    .padding(.leading)
                                    VStack(alignment: .center) {
                                        fontModifier(text: capitalizeFirstLetter(word: city), type: "Montserrat", size: 30, weight: .medium)
                                        
                                        HStack {
                                            imageSize(picture: weatherViewModel.weatherData!.icon, pWidht: 0.65, pHeight: 0.65)
                                            
                                            fontModifier(text: weatherViewModel.weatherData!.temp.roundDouble() + "°", type: "Montserrat", size: 102, weight: .light)
                                            Spacer()
                                            Spacer()
                                            
                                        }
                                    }
                                    .frame(width: containerWidth * 1)
                                    
                                   
                                }
                                DailyDataView(weatherViewModel: weatherViewModel, forecastViewModel: forecastViewModel)
                                
                            }
                            .padding(.bottom)
                            
                            ScrollView(showsIndicators: false) {
                                VStack {
                                    HStack {
                                        fontModifier(text: "Óránkénti előrejelzés", type: "Montserrat", size: 15, weight: .semibold)
                                        
                                        Spacer()
                                    }
                                    .padding(.leading)
                                    
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: containerWidth * 0.9, height: containerHeight * 0.005)
                                        .background(ColorTheme.offWhite)
                                    
                                    HourlyDataView(forecastViewModel: forecastViewModel)
                                    
                                }
                                
                                VStack {
                                    
                                    WeeklyForecastView(weatherViewModel: weatherViewModel, forecastViewModel: forecastViewModel, city: $city)
                                }
                                
                            }
                            .padding(.bottom, 85)
                            
                        }
                        .ignoresSafeArea(edges: .bottom)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    refreshWeatherData(city: city)
                                }) {
                                    Image(systemName: "arrow.clockwise")
                                }
                                .padding(0)
                                .foregroundColor(ColorTheme.darkBlue)
                            }
                        }
                    }
                    
                }
                
            }
            
            
        }
        .onAppear {
            if let token = UserDefaults.standard.string(forKey: "AuthToken") {
                fetchUserData(token: token) { result in
                    switch result {
                    case .success(let response):
                        DispatchQueue.main.async {
                            self.userData = response
                            if UserDefaults.standard.bool(forKey: "showCity") {
                                if locationManager.cityName == "" {
                                    self.city = userData?.city ?? ""
                                } else {
                                    self.city = locationManager.cityName
                                }
                            } else {
                                self.city = userData?.city ?? "Debrecen"
                            }
                            self.refreshWeatherData(city: self.city)
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
    
    func refreshWeatherData(city: String) {
        if let token = UserDefaults.standard.string(forKey: "AuthToken") {
            weatherViewModel.getWeatherData(city: city, token: token)
            forecastViewModel.getWeatherForecast(city: city, token: token)
        } else {
            print("Authentication token not found.")
        }
    }

}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
            .environmentObject(LocationManager())
            .environmentObject(LoginViewModel())
            .environmentObject(WeatherViewModel())
            .environmentObject(ForecastViewModel())
    }
}
