//
//  LoginAPI.swift
//  Weather
//
//  Created by user on 2023. 08. 09..
//

import Foundation

struct TokenResponse: Decodable {
    let token: String
}

class LoginManager {
    func loginUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        struct LoginData: Codable {
            let email: String
            let password: String
        }
        
        let loginData = LoginData(email: email, password: password)
        let apiURLString = "http://localhost:8080/api/Auth/login"
        
        guard let apiURL = URL(string: apiURLString) else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(loginData) else {
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
                do {
                    let decoder = JSONDecoder()
                    let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
                    completion(.success(tokenResponse.token))
                    print(tokenResponse.token)
                    
                    UserDefaults.standard.setValue(tokenResponse.token, forKey: "AuthToken")
                } catch {
                    print("Hiba történt a JWT token kinyerése közben: \(error.localizedDescription)")
                    completion(.failure(NetworkError.failedToDecodeResponse))
                }
            }
        }
        
        task.resume()
    }
}
