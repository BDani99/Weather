import UIKit
import PlaygroundSupport

struct AuthResponse: Decodable {
    let token: String
}

func authenticate(email: String, password: String, completion: @escaping (String?) -> Void) {
    let url = URL(string: "http://localhost:8080/api/Auth/login")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let loginData = [
        "email": email,
        "password": password
    ]
    
    let jsonData = try! JSONSerialization.data(withJSONObject: loginData)
    request.httpBody = jsonData
    
    let session = URLSession.shared
    
    let task = session.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Authentication Error: \(error)")
            completion(nil)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
            do {
                let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                let token = authResponse.token
                completion(token)
            } catch {
                print("Authentication Decoding Error: \(error)")
                completion(nil)
            }
        } else {
            print("Authentication Failed: Invalid credentials or server error.")
            completion(nil)
        }
    }
    
    task.resume()
}

func testWeatherAPI(city: String, token: String) {
    guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        fatalError("Invalid city name")
    }
    
    let url = URL(string: "http://localhost:8080/api/weather/now?city=\(encodedCity)")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let session = URLSession.shared
    
    let task = session.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Weather API Error: \(error)")
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Weather API Status code: \(httpResponse.statusCode)")
        }
        
        if let data = data {
            if let responseString = String(data: data, encoding: .utf8) {
                print("Weather API Response: \(responseString)")
            }
        }
    }
    
    task.resume()
}

authenticate(email: "teszt8@example.com", password: "Password8") { token in
    if let token = token {
        testWeatherAPI(city: "Győr", token: token)
    } else {
        print("Authentication failed. Weather API call not executed.")
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true
