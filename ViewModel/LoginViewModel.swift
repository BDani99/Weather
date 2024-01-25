//
//  LoginViewModel.swift
//  Weather
//
//  Created by user on 2023. 08. 09..
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var isAuthenticated: Bool = false
    @Published var accessToken = ""
    
    func login(email: String, password: String) {
        let defaults = UserDefaults.standard
        
        LoginManager().loginUser(email: email, password: password) { result in
            switch result {
            case .success(let token):
                defaults.setValue(token, forKey: "authToken")
                DispatchQueue.main.async { [weak self] in
                    self?.isAuthenticated = true
                    self?.accessToken = token

                }

            case .failure(let error):
                self.isAuthenticated = false
                UserDefaults.standard.set(false, forKey: "RememberMe")
                print(error.localizedDescription)
            }
            print(result)
        }
        
        
    }
    
    func signout() {
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "accessToken")
        DispatchQueue.main.async { [weak self] in
            self?.isAuthenticated = false
            self?.accessToken = ""
        }
        
        UserDefaults.standard.set(false, forKey: "RememberMe")
        
        
    }
}

