//
//  RegistretionViewModel.swift
//  Weather
//
//  Created by user on 2023. 08. 09..
//

import Foundation

class RegistrationViewModel: ObservableObject {
    var username = ""
    var email = ""
    var password1 = ""
    var password2 = ""
    var registrationError: String? = nil
    @Published var isRegistered: Bool = false
    
    func registerUser() {
        let registrationManager = RegistrationManager()
        
        if password1 == password2 {
            registrationManager.registerUser(name: username, email: email, password: password1) { result in
                switch result {
                case .success(_):
                    self.username = ""
                    self.email = ""
                    self.password1 = ""
                    self.password2 = ""
                    
                    self.isRegistered = true
                case .failure(let error):
                    self.registrationError = error.localizedDescription
                }
            }
        } else {
            self.registrationError = "A megadott jelszavak nem egyeznek"
            print("A megadott jelszavak nem egyeznek")
        }
    }
}
