//
//  WeatherAPI.swift
//  Weather
//
//  Created by user on 2023. 07. 28..
//

import Foundation
import SwiftUI


struct WeatherData: Codable {
    let main: String
    let temp: Double
    let wind: Double
    let feelsLike: Double
    let humidity: Double
    let icon: String
}

class WeatherAPIManager {
    func getWeatherData(city: String, token: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        
        let urlString = "http://localhost:8080/api/weather/now?city=\(encodedCity)"
        guard let apiURL = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(("Bearer \(token)"), forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.badResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.badStatus))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    completion(.success(weatherData))
                } catch {
                    completion(.failure(NetworkError.failedToDecodeResponse))
                }
            }
        }
        
        task.resume()
    }
}


class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var isAuthenticated: Bool = false
    @Published var accessToken: String = ""
    
    func getWeatherData(city: String, token: String) {
        WeatherAPIManager().getWeatherData(city: city, token: token) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    self?.weatherData = data
                    print(data)
                }
            case .failure(let error):
                print("Failed to fetch weather data: \(error.localizedDescription)")
            }
            print(result)
            print(token)
            
        }
    }
}

struct ForecastData: Codable, Identifiable {
    let date: Date
    let minTemp: Double
    let maxTemp: Double
    let main: String
    let wind: Double
    let feelsLike: Double
    let humidity: Double
    let temp: Double
    let icon: String
    
    var id: UUID {
        return UUID()
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    var dayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case minTemp
        case maxTemp
        case main
        case wind
        case feelsLike
        case humidity
        case temp
        case icon
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let dateString = try container.decodeIfPresent(String.self, forKey: .date),
           let date = dateFormatter.date(from: dateString) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Invalid date format")
        }
        
        minTemp = try container.decode(Double.self, forKey: .minTemp)
        maxTemp = try container.decode(Double.self, forKey: .maxTemp)
        main = try container.decode(String.self, forKey: .main)
        wind = try container.decode(Double.self, forKey: .wind)
        feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        humidity = try container.decode(Double.self, forKey: .humidity)
        temp = try container.decode(Double.self, forKey: .temp)
        icon = try container.decode(String.self, forKey: .icon)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        try container.encode(dateFormatter.string(from: date), forKey: .date)
        
        try container.encode(minTemp, forKey: .minTemp)
        try container.encode(maxTemp, forKey: .maxTemp)
        try container.encode(main, forKey: .main)
        try container.encode(wind, forKey: .wind)
        try container.encode(feelsLike, forKey: .feelsLike)
        try container.encode(humidity, forKey: .humidity)
    }
}

class ForecastAPIManager {
    func getWeatherForecast(city: String, token: String, completion: @escaping (Result<[ForecastData], Error>) -> Void) {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        
        let urlString = "http://localhost:8080/api/Weather/forecast?city=\(encodedCity)"
        guard let apiURL = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.badResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.badStatus))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601 // Specifies date format
                    let forecastData = try decoder.decode([ForecastData].self, from: data)
                    completion(.success(forecastData))
                } catch {
                    completion(.failure(NetworkError.failedToDecodeResponse))
                }
            }
        }
        
        task.resume()
    }
}

class ForecastViewModel: ObservableObject {
    @Published var forecastData: [ForecastData]?
    @Published var isAuthenticated: Bool = false
    @Published var accessToken: String = ""
    
    func getWeatherForecast(city: String, token: String) {
        ForecastAPIManager().getWeatherForecast(city: city, token: token) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    self?.forecastData = data
                    print(data)
                }
            case .failure(let error):
                print("Failed to fetch weather forecast: \(error.localizedDescription)")
            }
            print(result)
            print(token)
        }
    }
}

extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}
