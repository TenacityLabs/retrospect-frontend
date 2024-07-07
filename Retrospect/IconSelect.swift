//
//  IconSelect.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-05-24.
//

import SwiftUI

struct IconSelect: View {
    @Binding var state: String
    @StateObject private var dataStore = capsule()
    @State private var selectedIndex: Int = 0
    @State private var containers = ["Box", "Suitcase", "Guitar", "Jar", "Shoe"]
    
    var body: some View {
        VStack {
            Text("Pick a vessel, any vessel")
                .font(.title)
                .padding(.top, 80)
                .foregroundColor(.white)
            
            Spacer()
            
            TabView(selection: $selectedIndex) {
                ForEach(containers.indices, id: \.self) { index in
                    GeometryReader { geometry in
                            VStack {
                                Image(containers[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: .infinity, height: 300)
                                    .padding()
                                    .shadow(color: .pink, radius: 30, x: 0, y: 0)
                            }
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .edgesIgnoringSafeArea(.all)
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 10)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)
            
            HStack {
                ForEach(containers.indices, id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.white : Color.white.opacity(0.1))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: selectedIndex)
                }
            }
            .padding(.top, 10)
            Spacer()
            
            Button(action: {
                dataStore.container = selectedIndex
                state = "ChooseName"
            }) {
                Text("Confirm Selection")
                    .foregroundColor(Color.black)
                    .padding()
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            .padding(.bottom, 80)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        IconSelect(state: .constant(""))
    }
}

