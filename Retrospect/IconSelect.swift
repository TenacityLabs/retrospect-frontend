//
//  IconSelect.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-05-24.
//

import SwiftUI

struct IconSelect: View {
    @Binding var state: String
    @StateObject private var dataStore = DataStore()
    
    var body: some View { 
        NavigationStack {
            VStack {
                Text("Pick a container worthy of your selection:")
                    .font(.title)
                    .padding(.top, 50)
                
                Spacer()
                
                GridView(selectedIcon: $dataStore.selectedIcon)
                    .padding(.horizontal)
                
                Spacer()
                
                if dataStore.selectedIcon != nil {
                    Button("Next") {
                        state = "PhotoSelect"
                    }
                }
                
                // FIXME: Handle return to menu once menu is created
                Button("Return to menu") {
                    state = "Menu"
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal)
        }
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

struct IconSelectView_Previews: PreviewProvider {
    static var previews: some View {
        IconSelect(state: .constant(""))
    }
}
