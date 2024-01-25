//
//  regteszt.swift
//  Weather
//
//  Created by user on 2023. 07. 25..
//

import Foundation

func testRegistration() {
    let url = URL(string: "http://localhost:8080/api/User/registration")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let registrationData = [
        "name": "teszt4",
        "email": "teszt4@example.com",
        "password": "Password4"
    ]
    
    let jsonData = try! JSONSerialization.data(withJSONObject: registrationData)
    request.httpBody = jsonData
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Status code: \(httpResponse.statusCode)")
        }
        
        if let data = data {
            if let responseString = String(data: data, encoding: .utf8) {
                print("API válasz: \(responseString)")
            }
        }
    }
    
    task.resume()
}
