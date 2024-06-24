//
//  LandingPage.swift
//  Retrospect
//
//  Created by John Liu on 2024-06-23.
//

import SwiftUI

struct LandingPage: View {
    @State private var state = ""
    
    var body: some View {
        ZStack {
            if state == "login"{
                LoginPage(state: $state)
                    .transition(.slide)
                    .animation(.easeInOut)
            }
            else if state == "signup" {
                SignupPage(state: $state)
                    .transition(.slide)
                    .animation(.easeInOut)
            } else {
                BasicLanding(state: $state)
                    .transition(.slide)
                    .animation(.easeInOut)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

struct BasicLanding: View {
    @State private var started = false
    @Binding var state: String;
    
    var body: some View {
        VStack {
            Text("Retrospect")
                .font(.system(size: 28))
                .foregroundColor(.white)
            Spacer().frame(height: 20)
            Image("Logo White")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
            Spacer().frame(height: 30)
            if (started) {
                DarkStyledButton(title: "Sign Up"){
                    state = "signup"
                }
                DarkStyledButton(title: "Log In"){
                    state = "login"
                }
            }
            else {
                DarkStyledButton(title: "Get Started"){
                    started = true
                }
            }
        }
    }
}

struct SignupPage: View {
    @Binding var state: String;
    @State private var phoneNumber = ""
    @State private var name = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack {
            Image("Logo White")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
            Spacer().frame(height: 20)
            Text("Retrospect")
                .font(.system(size: 28))
                .foregroundColor(.white)
            Spacer().frame(height: 30)
            
            TextField("Phone Number", text: $phoneNumber)
                .padding()
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
            
            TextField("Name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            Spacer().frame(height: 50)
            LightStyledButton(title: "Sign Up") {
               
            }
            Spacer().frame(height: 10)
            HStack {
                Text("Already have an account?").foregroundColor(Color.gray)
                Spacer().frame(width: 10)
                Button(action: {
                    state = "login"
                }){
                    Text("Login").foregroundColor(Color(red:0.7, green:0.7, blue:0.7)).bold().underline()
                }
            }
        }
    }
}

struct LoginPage: View {
    @Binding var state: String;
    @State private var phoneNumber = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Image("Logo White")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
            Spacer().frame(height: 20)
            Text("Retrospect")
                .font(.system(size: 28))
                .foregroundColor(.white)
            Spacer().frame(height: 30)
            TextField("Phone Number", text: $phoneNumber)
                .padding()
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 5)
                .padding(.horizontal, 20)
            HStack {
                Spacer()
                Button(action: {
                    state = ""
                }){
                    Text("Forgot Password?").foregroundColor(Color(red:0.7, green:0.7, blue:0.7)).bold().underline()
                }
            }
            .padding(.bottom, 10)
            .padding(.horizontal, 20)
            Spacer().frame(height: 50)
            LightStyledButton(title: "Login") {
                
            }
            Spacer().frame(height: 10)
            HStack {
                Text("Don't have an account?").foregroundColor(Color.gray)
                Spacer().frame(width: 10)
                Button(action: {
                    state = "signup"
                }){
                    Text("Sign Up").foregroundColor(Color(red:0.7, green:0.7, blue:0.7)).bold().underline()
                }
            }
        }
    }
}

private func LightStyledButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action){
            Text(title)
            .font(.system(size: 18))
            .foregroundColor(.black)
        }
        .padding(.vertical, 8)
        .frame(width: 200)
        .background(Color(red: 0.9, green: 0.9, blue: 0.9))
        .cornerRadius(.infinity)
}


private func DarkStyledButton(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action){
            Text(title)
            .font(.system(size: 18))
            .foregroundColor(.white)
        }
        .padding(.vertical, 8)
        .frame(width: 200)
        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
        .cornerRadius(.infinity)
}

#Preview {
    LandingPage();
}


