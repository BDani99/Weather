//
//  LoginView.swift
//  Weather
//
//  Created by user on 2023. 07. 12..
//

import SwiftUI

struct LoginView: View {
    @State var email = "teszt8@example.com"
    @State var password = "Password8"
    @State var showPassword: Bool = false
    @State var isOn: Bool = false
    @EnvironmentObject var loginVM: LoginViewModel
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .modifier(DefaultBackground())
                
               
                VStack(alignment: .center){
                    Spacer()
                    VStack {
                        fontModifier(text: "Bejelentkezés", type: "Montserrat", size: 24, weight: .medium)
                            .modifier(CustomHeaderModifier())
                        
                
                        imageSize(picture: "Cloud", pWidht: 0.7, pHeight: 0.9)
                    }
                    
                    VStack(alignment: .leading) {
                        
                        fontModifier(text: "Üdv Felhasználó", type: "Montserrat", size: 18, weight: .medium)
                        
                        fontModifier(text: "Jelentkezzen be a folytatáshoz", type: "Montserrat", size: 18, weight: .light)
                        
                    }
                    .frame(width: containerWidth * 0.88, alignment: .leading)
                    
                    VStack {
                        customTextField(text: "Email", picture: "mail.fill", username: $email)
                            .textContentType(.username)
                        
                        
                        HStack {
                            if showPassword {
                                HStack {
                                    customTextField(text: "Jelszó", picture: "lock.fill", username: $password)
                                        .textContentType(.password)
                                    
                                    Button {
                                        showPassword.toggle()
                                    } label: {
                                        Image(systemName: showPassword ? "eye.slash" : "eye")
                                            .foregroundColor(ColorTheme.textColor)
                                    }
                                    .padding(.leading, -60)
                                    
                                }
                             
                                
                            } else {
                                
                                HStack {
                                    customSecureField(text: "Jelszó", picture: "lock.fill", username: $password)
                                        .textContentType(.password)
                                    
                                    Button {
                                        showPassword.toggle()
                                    } label: {
                                        Image(systemName: showPassword ? "eye.slash" : "eye")
                                            .foregroundColor(ColorTheme.textColor)
                                        
                                    }
                                    .padding(.leading, -60)
                                    
                                }
                               
                            }
                        }
                        .modifier(CustomTextModifier())
                   
                        
                        VStack(alignment: .leading){
                            HStack() {
                                Toggle(isOn: $isOn) {
                                    
                                }
                                .toggleStyle(CheckboxToggleStyle())
                                .frame(width: containerWidth * 0.05, height: containerHeight * 0.022)
                       
                                
                                fontModifier(text: "Emlékezz rám", type: "Montserrat", size: 14, weight: .light)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                            }
                            .padding(.leading)
                          
                        }
                        .padding()
                        
                    }
  
                    VStack{
                        Button {
                            isItOn()
                            loginVM.login(email: email, password: password)
                            
                        } label: {
                            
                            buttonFontModifier(text: "Bejelentkezés", type: "Montserrat", size: 20, weight: .medium)
                                .modifier(CustomButtonModifier())

                        }
                        .padding(.top)
                   
                        HStack {
                            fontModifier(text: "Még nincs fiókja?", type: "Montserrat", size: 14, weight: .light)
                                .kerning(0.7)
                            
                            NavigationLink(destination: PreView1()) {
                                fontModifier(text: "Regisztrálj", type: "Montserrat", size: 14, weight: .bold)
                                    .kerning(0.7)
                            }
                        }
                       
                    }
                  Spacer()
                }
            }
            
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func isItOn() {
        if isOn {
            UserDefaults.standard.set(true, forKey: "RememberMe")
        } else {
            UserDefaults.standard.set(false, forKey: "RememberMe")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginViewModel())
    }
}

