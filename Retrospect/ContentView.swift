//
//  ContentView.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-05-23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedIcon: Int? = UserDefaults.standard.integer(forKey: "selectedIcon")
    
    var body: some View {
        VStack {
            Text("Pick a container worthy of your selection:")
                .font(.title)
                .padding(.top, 10) 
            
            Spacer()
            GridView(selectedIcon: $selectedIcon)
                .padding(.horizontal)
            Spacer()
            
            Button(action: {
                // Handle return to menu
            }) {
                Text("Return to menu")
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
    }
}

struct GridView: View {
    @Binding var selectedIcon: Int?
    
    let icons = ["icon1", "icon2", "icon3", "icon4"]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(0..<icons.count, id: \.self) { index in
                Button(action: {
                    selectedIcon = index
                    UserDefaults.standard.set(index, forKey: "selectedIcon")
                }) {
                    Text("icon")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedIcon == index ? Color.blue : Color.gray)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
    }
}
