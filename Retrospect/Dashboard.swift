//
//  Dashboard.swift
//  Retrospect
//
//  Created by John Liu on 2024-06-26.
//

import SwiftUI

struct Dashboard: View {
    @Binding var state: String
    
    var body: some View {
        VStack {
            Text("Your Capsules")
                .font(.custom("IvyOraDisplay-Regular", size: 48))
                .foregroundColor(.white)
                .padding(.top, 50)
                    
            VStack(alignment: .center) {
                Spacer()
                Image("Box")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .shadow(color: .pink, radius: 30, x: 0, y: 0)

                Text("Create your first capsule")
                    .foregroundColor(.white)
                    .font(.custom("Syne-Bold", size: 24))
                Spacer()
            }
            .frame(width: 350, height: 290, alignment: .center)
            .background(Color.white.opacity(0.1))
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(
                  Color(red: 1, green: 1, blue: 1).opacity(0.60), lineWidth: 0.50
                )
            )
            .shadow(
              color: Color(red: 1, green: 1, blue: 1, opacity: 0.30), radius: 20
            )
        }
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        Dashboard(state: .constant(""))
    }
}


