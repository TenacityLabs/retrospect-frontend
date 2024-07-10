//
//  CapsuleRouter.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-07.
//

import SwiftUI

struct CapsuleRouter: View {
    @State private var capsuleState = "IconSelect"
    @StateObject private var dataStore = capsule()

    var body: some View {
        ZStack {
            if capsuleState == "IconSelect" {
                IconSelect(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if capsuleState == "ChooseName" {
                ChooseName(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if capsuleState == "PhotoSelect" {
                PhotoSelect(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if capsuleState == "SongSelect" {
                SongSelect(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(dataStore)
                    .environmentObject(SpotifyManager())
            } else if capsuleState == "AnswerPrompt" {
                AnswerPrompt(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if capsuleState == "AdditionalGoodies" {
                AdditionalGoodiesRouter(capsuleState: $capsuleState)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if capsuleState == "SetDate" {
                SetDate(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if capsuleState == "SealBox" {
                SealCapsuleView(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(dataStore)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    CapsuleRouter()
}
