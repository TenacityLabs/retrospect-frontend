//
//  ChooseName.swift
//  Retrospect
//
//  Created by John Liu on 2024-06-14.
//

import SwiftUI

struct ChooseName: View {
    @State private var name: String = ""
    @Binding var state: String
        
    var body: some View {
        VStack {
            Text("Give your Capsule the perfect name")
                .font(.custom("IvyOraDisplay-Regular", size: 48))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, 50)
            
            TextField("", text: $name.max(100))
                .placeholder(when: name.isEmpty) {
                    Text("Jessica's Capsule").foregroundColor(.gray)
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(25)
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.bottom, 50)
            
            Button(action: {
                capsuleName = name
                state = "Collab"
            }) {
                Text("I'm ready to go!")
                    .foregroundColor(Color.black)
                    .padding()
                    .frame(width: 300)
                    .background(name.isEmpty ? Color.white.opacity(0.5) : Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            .disabled(name.isEmpty)
            
            Spacer()
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        ChooseName(state: .constant(""))
    }
}

