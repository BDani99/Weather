//
//  WeeklyForecastView.swift
//  Weather
//
//  Created by user on 2023. 08. 01..
//

import Foundation
import SwiftUI


struct DayForecast: Identifiable {
    let id = UUID()
    let dayOfWeek: String
    let date: Date
    let icon: String
    let temp: Double
    let humidity: Double
    let wind: Double
    let minTemp: Double
    let maxTemp: Double
    let feelsLike: Double
}

struct WeeklyForecastView: View {
    @ObservedObject var weatherViewModel: WeatherViewModel
    @ObservedObject var forecastViewModel: ForecastViewModel
    @Binding var city: String
    @State private var isShowingWeeklyForecast = false
    @State private var selectedForecast: ForecastData?
    @State private var isShowingDailyForecast = false
    @State private var selectedDayForecast: DayForecast? = nil
    
    var body: some View {
        
        VStack {
            headerView
            forecastListView
        }
        .sheet(isPresented: Binding(
            get: { isShowingDailyForecast },
            set: { isShowingDailyForecast = $0 }
        ), content: {
            if let selectedForecast = selectedDayForecast {
                dailyForecastSheet(for: selectedForecast)
            }
        })
        
    }
    
    private var headerView: some View {
        VStack {
            HStack {
                fontModifier(text: "Heti előrejelzés", type: "Montserrat", size: 15, weight: .semibold)
                    .padding(.leading)
                
                
                Spacer()
                
                fontModifier(text: "Min | Max", type: "Montserrat", size: 15, weight: .light)
                    .padding(.trailing)
                
            }
            .padding(.top)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: containerWidth * 0.9, height: containerHeight * 0.005)
                .background(ColorTheme.offWhite)
        }
    }
    
    private var forecastListView: some View {
        if let forecastData = forecastViewModel.forecastData, !forecastData.isEmpty {
            let weeklyForecasts = calculateWeeklyForecasts(from: forecastData)
            return AnyView(VStack(spacing: 15) {
                ForEach(weeklyForecasts.sorted(by: { $0.date < $1.date }), id: \.id) { forecast in
                    weeklyForecastRow(for: forecast)
                }
            })
        } else {
            return AnyView(Text("Adatok betöltése...")
                .foregroundColor(.gray))
        }
    }
    
    private func calculateWeeklyForecasts(from forecastData: [ForecastData]) -> [DayForecast] {
        let calendar = Calendar.current
        let uniqueDays = Set(forecastData.compactMap { forecast in
            calendar.dateComponents([.weekday], from: forecast.date).weekday
        })
        
        var weeklyForecasts: [DayForecast] = []
        
        for day in uniqueDays {
            let filteredData = forecastData.filter { calendar.dateComponents([.weekday], from: $0.date).weekday == day }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            if let date = filteredData.first?.date {
                let dayOfWeek = dateFormatter.string(from: date)
                let icon = filteredData.first?.icon ?? "default"
                let temp = filteredData.first?.temp ?? 0.0
                let humidity = filteredData.first?.humidity ?? 0.0
                let wind = filteredData.first?.wind ?? 0.0
                let minTemp = filteredData.min(by: { $0.minTemp < $1.minTemp })?.minTemp ?? 0.0
                let maxTemp = filteredData.max(by: { $0.maxTemp < $1.maxTemp })?.maxTemp ?? 0.0
                let feelsLike = filteredData.first?.feelsLike ?? 0.0
                
                weeklyForecasts.append(DayForecast(dayOfWeek: dayOfWeek, date: date, icon: icon, temp: temp, humidity: humidity, wind: wind, minTemp: minTemp, maxTemp: maxTemp, feelsLike: feelsLike))
            }
        }
        
        return weeklyForecasts
    }
    
    private func weeklyForecastRow(for dayForecast: DayForecast) -> some View {
        return HStack {
            Text(dayForecast.dayOfWeek)
                .padding(.leading)
                .frame(width: 90)
            
            Spacer()
            imageSize(picture: dayForecast.icon, pWidht: 0.52, pHeight: 0.52)
           
            
            Spacer()
            
            Text("\(dayForecast.minTemp.roundDouble())° | \(dayForecast.maxTemp.roundDouble())°")
                .padding(.trailing)
        }
        .frame(width: containerWidth * 0.90, height: containerHeight * 0.065)
        .background(ColorTheme.darkBlue)
        .cornerRadius(60)
        .shadow(color: .black.opacity(0.1), radius: 0.5, x: 1, y: 1)
        .foregroundColor(.white)
        .onTapGesture {
            selectedDayForecast = dayForecast
            isShowingDailyForecast = true
        }
    }
    
    @ViewBuilder
    private func dailyForecastSheet(for dayForecast: DayForecast) -> some View {
        VStack {
            if weatherViewModel.weatherData != nil && forecastViewModel.forecastData != nil {
                ZStack {
                    Rectangle()
                        .modifier(DefaultBackground())
                    
                    VStack {
                        VStack(alignment: .center) {
                            fontModifier(text: capitalizeFirstLetter(word: city), type: "Montserrat", size: 30, weight: .medium)
                                .padding(.top)
                            
                            HStack {
                                imageSize(picture: dayForecast.icon, pWidht: 0.55, pHeight: 0.55)
                                
                                fontModifier(text: "\(dayForecast.temp.roundDouble())°", type: "Montserrat", size: 102, weight: .light)
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
                                        Text("Páratartalom: \(dayForecast.humidity.roundDouble()) %")
                                            .font(Font.custom("Montserrat", size: 12))
                                            .foregroundColor(ColorTheme.textColor)
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Image(systemName: "sun.max")
                                                .resizable()
                                                .frame(width: containerWidth * 0.05, height: containerHeight * 0.022)
                                            Text("Min/Max \(dayForecast.minTemp.roundDouble())°/ \(dayForecast.maxTemp.roundDouble())°")
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
                                        Text("Hőérzet: \(dayForecast.feelsLike.roundDouble()) C°")
                                            .font(Font.custom("Montserrat", size: 12))
                                            .foregroundColor(ColorTheme.textColor)
                                            .padding(.trailing)
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Image(systemName: "wind")
                                                .resizable()
                                                .frame(width: containerWidth * 0.05, height: containerHeight * 0.022)
                                            Text("Szél: \(dayForecast.wind.roundDouble()) km/h")
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
                            
                            HourlyDateDataView(forecastViewModel: forecastViewModel, selectedDayForecast: selectedDayForecast)
                                .padding(.top)
                        }
                        .padding(.top)
                        
                    }
                }
                
            }
        }
        .presentationDetents([.height(550)])
    }
}
