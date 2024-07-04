//
//  SignUp.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-03.
//

import SwiftUI

import SwiftUI

struct SignUp: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var registrationResult: String = ""
    
    var body: some View {
        VStack {
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                register()
            }) {
                Text("Register")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Text(registrationResult)
                .padding()
                .foregroundColor(.red)
        }
        .padding()
    }
    
    private func register() {
        APIClient.shared.register(firstName: firstName, lastName: lastName, email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    registrationResult = "Registration successful!"
                case .failure(let error):
                    registrationResult = "Registration failed: \(error)"
                    print(registrationResult)
                }
            }
        }
    }
}

#Preview {
    SignUp()
}
 
