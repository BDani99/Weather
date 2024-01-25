//
//  UserAPI.swift
//  Weather
//
//  Created by user on 2023. 07. 27..
//

import Foundation


struct UserResponse: Codable {
    let username: String
    let unitOfMeasure: String
    let city: String
    let defaultPage: String
}

func fetchUserData(token: String, completion: @escaping (Result<UserResponse, Error>) -> Void) {
    guard let url = URL(string: "http://localhost:8080/api/User") else {
        completion(.failure(NetworkError.badUrl))
        return
    }
    
    var request = URLRequest(url: url)
    request.addValue("text/plain", forHTTPHeaderField: "accept")
    request.addValue("bearer \(token)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
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
        
        guard let data = data else {
            completion(.failure(NetworkError.failedToDecodeResponse))
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let userResponse = try decoder.decode(UserResponse.self, from: data)
            completion(.success(userResponse))
        } catch {
            completion(.failure(NetworkError.failedToDecodeResponse))
        }
    }.resume()
}
