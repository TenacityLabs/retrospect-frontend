//
//  Router.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-29.
//

import SwiftUI

struct Router: View {
    @State private var state = "IconSelect"
    @State private var dataStore = DataStore()
    
    var body: some View {
        ZStack {
            BackgroundImageView()
            if state == "IconSelect"{
                IconSelect(state: $state)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if state == "PhotoSelect" {
                PhotoSelect(state: $state)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if state == "SongSelect" {
                SongSelect(state: $state)
                    .transition(.slide)
                    .environmentObject(dataStore)
                    .environmentObject(SpotifyManager())
            } else if state == "AnswerPrompt" {
                AnswerPrompt(state: $state)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if state == "AdditionalGoodies" {
                AdditionalGoodiesRouter(state: $state)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if state == "ChooseName" {
                ChooseName(state: $state)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if state == "SealBox" {
                SealBox(state: $state)
                    .transition(.slide)
                    .environmentObject(dataStore)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    Router()
}
