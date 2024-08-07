//
//  Dashboard.swift
//  Retrospect
//
//  Created by John Liu on 2024-06-26.
//

import SwiftUI

struct Dashboard: View {
    @Binding var state: String
    @State var capsules: [CapsuleData] = []
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Your Capsules")
                    .font(.custom("IvyOraDisplay-Regular", size: 48))
                    .foregroundColor(.white)
                    .padding(.top, 80)
                
                Spacer()

                Button(action: {
                    state = "Capsule"
                }) {
                    VStack {
                        Spacer()
                        
                        Image("emptybox")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 130)
                            .shadow(color: .white, radius: 60, x: 0, y: 0)
                        
                        Spacer()
                        
                        Text("Create your first capsule")
                            .foregroundColor(.white)
                            .font(.custom("Syne-Bold", size: 22))
                        
                        Spacer()
                    }
                    .frame(width: (geometry.size.width - 50), height: 250)
                    .background(Color(red: 44/255, green: 44/255, blue: 44/255).opacity(0.9))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                    .frame(height: 20)
                
                VStack {
                    Spacer()

                    Text("populate this space with more time capsules!")
                        .foregroundColor(Color.white.opacity(0.34))
                        .multilineTextAlignment(.center)
                        .font(.custom("Syne-Bold", size: 16))
                    
                    Spacer()
                }
                .frame(width: (geometry.size.width - 50), height: 150)
                .background(Color.white.opacity(0.1))
                .shadow(color: .white.opacity(0.1), radius: 10, x: 0, y: 0)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                
                Spacer()
                    .frame(height: 20)
                
                VStack {
                    Spacer()

                    Text("someone’s lonely and \n friend-less today")
                        .foregroundColor(Color.white.opacity(0.34))
                        .multilineTextAlignment(.center)
                        .font(.custom("Syne-Bold", size: 16))
                    
                    Spacer()
                }
                .frame(width: (geometry.size.width - 50), height: 150)
                .background(Color.white.opacity(0.1))
                .shadow(color: .white.opacity(0.1), radius: 10, x: 0, y: 0)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .edgesIgnoringSafeArea(.all)
    }

}

#Preview {
    ZStack {
        BackgroundImageView()
        Dashboard(state: .constant(""))
    }
}


