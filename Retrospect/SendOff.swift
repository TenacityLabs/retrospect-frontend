//
//  SendOff.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-10-06.
//

import SwiftUI

struct SendOff: View {
//    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        VStack {
            HStack {
                Image("box")
                    .resizable()
                    .frame(width: 80, height: 80)
                
                Spacer()
                
                Text("Jessica's Box")
                    .font(.custom("IvyOraDisplay-RegularItalic", size: 56))
                    .foregroundColor(.white)
            }
            
            Spacer()
                .frame(height: 80)
            
            Text("Capsule Status")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("Syne", size: 24))
                .foregroundColor(.white)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.bottom, 15)
            
            HStack() {
                Image("Vinyl")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(1000)
                
                Spacer()
                    .frame(width: 20)
                
                Text("William Jiang")
                    .foregroundColor(.white)
                    .font(.custom("Public Sans", size: 16))
                
                Spacer()
                
                Text("Sent")
                    .foregroundColor(Color(red: 0.09, green: 0.75, blue: 0.47))
                    .padding(12)
                    .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                    .cornerRadius(1000)
                
                Spacer()
                    .frame(width: 20)
                
                Image("VDots")
            }
            HStack() {
                Image("Vinyl")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(1000)
                
                Spacer()
                    .frame(width: 20)
                
                Text("William Jiang")
                    .foregroundColor(.white)
                    .font(.custom("Public Sans", size: 16))
                
                Spacer()
                
                Text("Sent")
                    .foregroundColor(Color(red: 0.09, green: 0.75, blue: 0.47))
                    .padding(12)
                    .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                    .cornerRadius(1000)
                
                Spacer()
                    .frame(width: 20)
                
                Image("VDots")
            }
            HStack() {
                Image("Vinyl")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(1000)
                
                Spacer()
                    .frame(width: 20)
                
                Text("William Jiang")
                    .foregroundColor(.white)
                    .font(.custom("Public Sans", size: 16))
                
                Spacer()
                
                Text("Sent")
                    .foregroundColor(Color(red: 0.09, green: 0.75, blue: 0.47))
                    .padding(12)
                    .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                    .cornerRadius(1000)
                
                Spacer()
                    .frame(width: 20)
                
                Image("VDots")
            }
            HStack() {
                Image("Vinyl")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(1000)
                
                Spacer()
                    .frame(width: 20)
                
                Text("William Jiang")
                    .foregroundColor(.white)
                    .font(.custom("Public Sans", size: 16))
                
                Spacer()
                
                Text("Sent")
                    .foregroundColor(Color(red: 0.09, green: 0.75, blue: 0.47))
                    .padding(12)
                    .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                    .cornerRadius(1000)
                
                Spacer()
                    .frame(width: 20)
                
                Image("VDots")
            }
            HStack() {
                Image("Vinyl")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(1000)
                
                Spacer()
                    .frame(width: 20)
                
                Text("William Jiang")
                    .foregroundColor(.white)
                    .font(.custom("Public Sans", size: 16))
                
                Spacer()
                
                Text("Not Sent")
                    .foregroundColor(Color(red: 0.8, green: 0.64, blue: 0.05))
                    .padding(12)
                    .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                    .cornerRadius(1000)
                
                Spacer()
                    .frame(width: 20)
                
                Image("VDots")
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.top, 15)
            
            HStack {
                Text("5/5 Collaborators Added")
                    .foregroundColor(.white)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "plus")
                        .foregroundColor(.gray)
                        .font(.system(size: 20, weight: .regular))
                }
            }
            .padding(.top, 20)
            
            Text("All collaborators must be ready to seal the capsule.")
                .font(.custom("Public Sans", size: 12))
                .foregroundColor(.white)
                .padding(.vertical, 20)
            
            HStack() {
                Text("Seal my capsule")
                .font(
                Font.custom("Syne", size: 18)
                .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            }
            .padding(24)
            .frame(maxWidth: .infinity, minHeight: 62, maxHeight: 62, alignment: .center)
            .background(Color(red: 0.25, green: 0.25, blue: 0.25))
            .cornerRadius(60)
            .overlay(
              RoundedRectangle(cornerRadius: 60)
                .inset(by: 0.5)
                .stroke(.white.opacity(0.4), lineWidth: 1)
            )
        }
        .padding(20)
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        SendOff()
    }
}
