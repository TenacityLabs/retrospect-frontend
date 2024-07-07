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
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                login()
            }) {
                Text("Login")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Text(loginResult)
                .padding()
                .foregroundColor(.red)
        }
        .padding()
    }
    
    private func login() {
        APIClient.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    loginResult = "Login successful! Token: \(token)"
                    jwt = token.token
                case .failure(let error):
                    loginResult = "Login failed: \(error)"
                }
            }
        }
    }
}


#Preview {
    Login()
}
