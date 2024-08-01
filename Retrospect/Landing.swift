//
//  Landing.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-07.
//

import SwiftUI

struct Landing: View {
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Text("Retrospect")
                .font(.custom("IvyOraDisplay-Light", size: 64))
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
                globalState.route = "/signup"
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
                globalState.route = "/login"
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
        Landing()
    }
}
