//
//  RegistrationView.swift
//  Weather
//
//  Created by user on 2023. 07. 12..
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var register: RegistrationViewModel
    @State private var isRegistered = false
    @State private var showAlert = false
    @State private var navigateToLoginView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .modifier(DefaultBackground())
                
                VStack(alignment: .center) {

                    VStack{
                        fontModifier(text: "Regisztráció", type: "Montserrat", size: 24, weight: .medium)
                            .modifier(CustomHeaderModifier())
                        
                        
                        imageSize(picture: "Cloud", pWidht: 1, pHeight: 1)
                        
                    }
                    
                    VStack(alignment: .leading) {
                        
                            
                            fontModifier(text: "Üdv Felhasználó", type: "Montserrat", size: 18, weight: .medium)
                        
       
                            fontModifier(text: "Kérjük, adja meg az alábbi adatait", type: "Montserrat", size: 16, weight: .light)
                    }
                    .frame(width: containerWidth * 0.88, alignment: .leading)
                    
                    VStack(spacing: 10) {
                        customTextField(text: "Név", picture: "person.fill", username: $register.username)
                            .modifier(CustomTextModifier())
                        
                        customTextField(text: "Email", picture: "mail.fill", username: $register.email)
                            .modifier(CustomTextModifier())
                        
                        customSecureField(text: "Jelszó", picture: "lock.fill", username: $register.password1)
                            .modifier(CustomTextModifier())
                        
                        customSecureField(text: "Jelszó", picture: "lock.fill", username: $register.password2)
                            .modifier(CustomTextModifier())
                    }
                    VStack{
                        Button {
                            register.registerUser()
                            showAlert = true
                        } label: {
                            buttonFontModifier(text: "Regisztráció", type: "Montserrat", size: 20, weight: .medium)
                                .modifier(CustomButtonModifier())
                        }
                        .padding(.top)
                        
                        Button {
                            
                        } label: {
                            fontModifier(text: "Már van fiókja?", type: "Montserrat", size: 14, weight: .light)
                                .kerning(0.7)
                            
                            NavigationLink(destination: LoginView()) {
                                fontModifier(text: "Bejelentkezés", type: "Montserrat", size: 14, weight: .bold)
                                    .kerning(0.7)
                            }
                        }
                        .padding(.bottom)
                        
                        
                    }
                    
                }
                
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(register.isRegistered == false ? "Hibás adatok" : "Sikeres regisztráció"),
                message: Text(register.isRegistered == false ? String(register.registrationError!) : "A regisztráció sikeresen megtörtént."),
                primaryButton: .default(Text(register.isRegistered == false ? "Rendben" : "Bejelentkezés")) {
                    if register.isRegistered == false {
                
                    } else {
                        navigateToLoginView = true
                    }
                }, secondaryButton: Alert.Button.cancel(Text("Mégse"), action: {
                })
            )
        }
        .background(
            NavigationLink(
                destination: LoginView(),
                isActive: $navigateToLoginView
            ) {
                EmptyView()
            }
        )
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(RegistrationViewModel())
    }
}
