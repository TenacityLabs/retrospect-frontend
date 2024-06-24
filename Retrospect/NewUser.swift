//
//  NewUser.swift
//  Retrospect
//
//  Created by John Liu on 2024-06-23.
//

import SwiftUI

struct NewUser: View {
    @State private var started = false
    
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
                StyledButton(title: "Sign Up"){
                    
                }
                StyledButton(title: "Log In"){
                }
            }
            else {
                StyledButton(title: "Get Started"){
                    started = true
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

func StyledButton(title: String, action: @escaping () -> Void) -> some View {
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
    NewUser();
}


