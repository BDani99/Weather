//
//  RegistrationAPI.swift
//  Weather
//
//  Created by user on 2023. 07. 24..
//

import Foundation

class RegistrationManager {
    func registerUser(name: String, email: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
        struct RegistrationData: Codable {
            let name: String
            let email: String
            let password: String
        }
        
        let registrationData = RegistrationData(name: name, email: email, password: password)
        let apiURLString = "http://localhost:8080/api/User/registration"
        
        guard let apiURL = URL(string: apiURLString) else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(registrationData) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
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
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.failedToDecodeResponse))
            }
        }
        
        task.resume()
    }
}

struct RegistrationData: Codable {
    let name: String
    let email: String
    let password: String
}
