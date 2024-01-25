//
//  WeatherSheetView.swift
//  Weather
//
//  Created by user on 2023. 08. 01..
//

import Foundation
import SwiftUI

struct WeatherSheetView: View {
    let cityName: String
    let weatherData: WeatherData
    @ObservedObject var forecastViewModel: ForecastViewModel
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .modifier(DefaultBackground())
            
            VStack(alignment: .center) {
                VStack {
                   
                    fontModifier(text: capitalizeFirstLetter(word: cityName), type: "Montserrat", size: 30, weight: .medium)
                        .padding(.leading)
                    
                    HStack {
                        imageSize(picture: weatherData.icon, pWidht: 0.6, pHeight: 0.6)
                        
                        
                        fontModifier(text: weatherData.temp.roundDouble() + "°", type: "Montserrat", size: 102, weight: .light)
                        Spacer()
                        Spacer()
                        
                    }
                }
                
                VStack {
                    Spacer()
                    HStack{
                        VStack{
                            HStack {
                                
                                Spacer()
                                
                                Image(systemName: "humidity.fill")
                                    .resizable()
                                    .frame(width: containerWidth * 0.05, height: containerHeight * 0.022)
                                Text("Páratartalom: \(weatherData.humidity.roundDouble()) %")
                                    .font(Font.custom("Montserrat", size: 12))
                                    .foregroundColor(ColorTheme.textColor)
                                
                                Spacer()
                                
                                HStack {
                                    Image(systemName: "sun.max")
                                        .resizable()
                                        .frame(width: containerWidth * 0.05, height: containerHeight * 0.022)
                                    
                                    let today = Date()
                                    let todayForecast = forecastViewModel.forecastData?.filter { Calendar.current.isDate($0.date, inSameDayAs: today)}
                                    Text("Min/Max \(todayForecast!.min(by: { $0.minTemp < $1.minTemp })!.minTemp.roundDouble())°/ \(todayForecast!.max(by: { $0.maxTemp < $1.maxTemp })!.maxTemp.roundDouble())°")
                                }
                                .font(Font.custom("Montserrat", size: 12))
                                .foregroundColor(ColorTheme.textColor)
                                
                                Spacer()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack{
                        VStack{
                            HStack {
                                
                                Spacer()
                                
                                Image(systemName: "thermometer.sun.fill")
                                    .resizable()
                                    .frame(width: containerWidth * 0.05, height: containerHeight * 0.022)
                                Text("Hőérzet: \(weatherData.feelsLike.roundDouble()) C°")
                                    .font(Font.custom("Montserrat", size: 12))
                                    .foregroundColor(ColorTheme.textColor)
                                    .padding(.trailing)
                                
                                Spacer()
                                
                                HStack {
                                    Image(systemName: "wind")
                                        .resizable()
                                        .frame(width: containerWidth * 0.05, height: containerHeight * 0.022)
                                    Text("Szél: \(weatherData.wind.roundDouble()) km/h")
                                }
                                .font(Font.custom("Montserrat", size: 12))
                                .foregroundColor(ColorTheme.textColor)
                                .padding(.trailing)
                                
                                Spacer()
                            }
                        }
                    }
                    Spacer()
                }
                .frame(width: containerWidth * 0.88, height: containerHeight * 0.12)
                .background(ColorTheme.offWhite)
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.1), radius: 0.5, x: 2, y: -1)
                .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0, y: 1)
                .padding(.bottom)
                
                HourlyDataView(forecastViewModel: forecastViewModel)
                Spacer()
            }
        }
    }
}
