//
//  SignUp.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-03.
//

import SwiftUI
import UIKit

struct SignUp: View {
    @State private var name: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var number: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var err: String = " "
    @Binding var state: String
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("Logo White")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            Text("Sign Up")
                .font(.custom("IvyOraDisplay-Regular", size: 48))
                .foregroundColor(.white)
            
            Spacer()
                .frame(height: 70)
            
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                
                TextField("name", text: $name)
                    .foregroundColor(.white)
                    .placeholder(when: name.isEmpty) {
                        Text("Full Name").foregroundColor(.gray)
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
                Image(systemName: "phone")
                    .foregroundColor(.gray)
                
                TextField("", text: $number)
                    .foregroundColor(.white)
                    .placeholder(when: number.isEmpty) {
                        Text("Phone Number").foregroundColor(.gray)
                    }
                    .autocapitalization(.none)
                    .accentColor(.white)
            }
            .padding()
            .frame(maxHeight: 60)
            .background(Color.black.opacity(0.5))
            .cornerRadius(30)
            .padding(.horizontal, 40)
            .padding(.bottom, 10)
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .placeholder(when: email.isEmpty) {
                        Text("Email").foregroundColor(.gray)
                    }
                    .autocapitalization(.none)
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
                        .placeholder(when: password.isEmpty) {
                            Text("Password").foregroundColor(.gray)
                        }
                        .autocapitalization(.none)
                        .accentColor(.white)
                } else {
                    SecureField("", text: $password)
                        .foregroundColor(.white)
                        .placeholder(when: password.isEmpty) {
                            Text("Password").foregroundColor(.gray)
                        }
                        .autocapitalization(.none)
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
            
            Spacer()
                .frame(height: 54)
            
            Text(err)
                .foregroundColor(.white)
            
            Button(action: {
                if (name.isEmpty || email.isEmpty || password.isEmpty) {
                    err = "Please fill out all fields"
                } else if !(isValidEmail(email)) {
                    err = "Invalid Email"
                } else if (password.count < 6) {
                    err = "Password must be at least 6 characters long"
                } else if (password.count > 130) {
                    err = "Password must be 130 characters or less"
                } else {
                    err = ""
                    register()
                }
            }) {
                Text("Sign Up")
                    .font(.custom("Syne-Regular", size: 18))
                    .foregroundColor(Color.black)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background((name.isEmpty || email.isEmpty || password.isEmpty) ? Color.white.opacity(0.5) : Color.white)
            .cornerRadius(30)
            .padding(.horizontal, 30)
            .padding(.bottom, 5)
            
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.white)
                Button(action: {
                    state = "Login"
                }) {
                    Text("Login")
                        .foregroundColor(Color.white.opacity(0.5))
                        .fontWeight(.bold)
                        .underline()
                }
            }
            
            Spacer()
            
//            Text(registrationResult)
//                .padding()
//                .foregroundColor(.red)
        }
    }
    
    //FIXME: handle failure case
    private func register() {
//        splitName()
        print(name, number, email, password)
        UserAPIClient.shared.register(Name: name, phone: number, email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    state = "Login"
                case .failure(let error):
                    err = "Registration failed: \(error)"
                    print(err)
                }
            }
        }
    }
    
    private func login() {
        UserAPIClient.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    jwt = token.token
                    state = "Dashboard"
                case .failure(_):
                    state = "Login"
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func splitName() {
        let components = name.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        if components.count > 1 {
            firstName = String(components[0])
            lastName = String(components[1])
        } else {
            firstName = name
            lastName = ""
        }
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        SignUp(state: .constant(""))
    }
}
 
