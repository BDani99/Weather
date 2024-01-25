//
//  HourlyDataView.swift
//  Weather
//
//  Created by user on 2023. 08. 01..
//

import Foundation
import SwiftUI

struct HourlyDataView: View {
    @ObservedObject var forecastViewModel: ForecastViewModel
    
    var body: some View {
        
        if let forecastData = forecastViewModel.forecastData {
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    Spacer()
                    ForEach(forecastData, id: \.date) { forecast in
                        if isToday(forecast.date) {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(ColorTheme.darkBlue)
                                .frame(width: containerWidth * 0.165, height: containerHeight * 0.17)
                                .overlay(
                                    VStack() {
                                        Spacer()
                                        Spacer()
                                        Text(forecast.formattedDate)
                                        
                                        imageSize(picture: forecast.icon, pWidht: 0.6, pHeight: 0.6)
                                        
                                        Text(forecast.minTemp.roundDouble())
                                        Spacer()
                                        Spacer()
                                    })
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .inset(by: 0.5)
                                        .stroke(.white, lineWidth: 1)
                                )
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(.trailing)
        }
    }
    
    private func isToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
}

struct HourlyDateDataView: View {
    @ObservedObject var forecastViewModel: ForecastViewModel
    var selectedDayForecast: DayForecast?
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    var body: some View {
        if let forecastData = forecastViewModel.forecastData, let selectedDayForecast = selectedDayForecast {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    Spacer()
                    ForEach(forecastData.filter({ isSameDay($0.date, selectedDayForecast.date) }), id: \.date) { forecast in
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(ColorTheme.darkBlue)
                            .frame(width: containerWidth * 0.165, height: containerHeight * 0.17)
                            .overlay(
                                VStack() {
                                    Spacer()
                                    Spacer()
                                    Text(forecast.formattedDate)
                                    
                                    imageSize(picture: forecast.icon, pWidht: 0.6, pHeight: 0.6)
                                    
                                    Text("\(forecast.minTemp.roundDouble())°")
                                    
                                    Spacer()
                                    Spacer()
                                })
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .inset(by: 0.5)
                                    .stroke(.white, lineWidth: 1)
                            )
                            .foregroundColor(.white)
                    }
                    
                }
            }
            .padding(.trailing)
        }
    }
}
