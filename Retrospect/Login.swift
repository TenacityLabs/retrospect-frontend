//
//  Login.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-04.
//

import SwiftUI

struct Login: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginResult: String = ""
    @State private var jwt: String = ""
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack {
            
            Image("Logo White")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            Text("Login")
                .font(.custom("IvyOraDisplay-Regular", size: 48))
                .foregroundColor(.white)
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .placeholder(when: email.isEmpty) {
                        Text("Email").foregroundColor(.gray)
                    }
                    .accentColor(.white)
            }
            .padding()
            .frame(maxHeight: 60)
            .background(Color.black.opacity(0.5))
            .cornerRadius(30)
            .padding(.horizontal, 40)
            .padding(.bottom, 10)
            
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                
                if isPasswordVisible {
                    TextField("", text: $password)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .placeholder(when: password.isEmpty) {
                            Text("Password").foregroundColor(.gray)
                        }
                        .accentColor(.white)
                } else {
                    SecureField("", text: $password)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .placeholder(when: password.isEmpty) {
                            Text("Password").foregroundColor(.gray)
                        }
                        .accentColor(.white)
                }
                
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                        .frame(width: 20, height: 20)
                }
                .padding(.trailing, 10)
            }
            .padding()
            .frame(maxHeight: 60)
            .background(Color.black.opacity(0.5))
            .cornerRadius(30)
            .padding(.horizontal, 40)
            .padding(.bottom, 80)
            
            Button(action: {
                login()
            }) {
                Text("Login")
                    .font(.custom("Syne-Regular", size: 18))
                    .foregroundColor(Color.black)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(Color.white)
            .cornerRadius(30)
            .padding(.horizontal, 30)
            .padding(.bottom, 5)
            
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.white)
                Button(action: {
//                    state = "SignUp"
                }) {
                    Text("Sign Up")
                        .foregroundColor(Color(red: 128/255, green: 128/255, blue: 128/255))
                        .fontWeight(.bold)
                        .underline()
                }
            }
        }
    }
    
    private func login() {
        APIClient.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    loginResult = "Login successful!"
                    jwt = token.token
                case .failure(_):
                    loginResult = "Login failed, please try again!"
                }
            }
        }
    }
}


#Preview {
    ZStack {
        BackgroundImageView()
        Login()
    }
}
