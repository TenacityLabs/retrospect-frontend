//
//  Landing.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-07.
//

import SwiftUI

struct Landing: View {
    @Binding var state: String
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Text("Retrospect")
                .font(.custom("IvyOraDisplay-Regular", size: 64))
                .foregroundColor(.white)
            
            Spacer()
                .frame(height: 96)
            
            Image("Logo White")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            Spacer()
                .frame(height: 96)
            
            Button(action: {
                state = "SignUp"
            }) {
                Text("Sign Up")
                    .font(.custom("Syne-Regular", size: 24))
                    .foregroundColor(Color.black)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 75)
            .background(Color.white)
            .cornerRadius(50)
            .padding(.horizontal, 30)
            .padding(.bottom, 15)
            
            Button(action: {
                state = "Login"
            }) {
                Text("Login")
                    .font(.custom("Syne-Regular", size: 24))
                    .foregroundColor(Color.black)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 75)
            .background(Color.white)
            .cornerRadius(50)
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        Landing(state: .constant(""))
    }
}
