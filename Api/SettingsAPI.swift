//
//  SettingsAPI.swift
//  Weather
//
//  Created by user on 2023. 07. 13..
//

import Foundation

struct UpdateUserData: Codable {
    let username: String
    let unitOfMeasure: String
    let city: String
    let defaultPage: String
}

class UpdateUserManager: ObservableObject {
    func updateUser(userData: UpdateUserData, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:8080/api/User/update-user") else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(userData)
            request.httpBody = jsonData
        } catch {
            completion(.failure(NetworkError.failedToEncodeRequest))
            return
        }
        
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
            
            completion(.success(()))
        }
        
        task.resume()
    }
}
