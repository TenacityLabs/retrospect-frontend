//
//  CapsuleRouter.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-07.
//

import SwiftUI

struct CapsuleRouter: View {
    @State private var capsuleState = "IconSelect"
    @State private var localCapsule = capsule()
    
    var body: some View {
        ZStack {
            BackgroundImageView()
            if capsuleState == "IconSelect" {
                IconSelect(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            } else if capsuleState == "ChooseName" {
                ChooseName(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            } else if capsuleState == "PhotoSelect" {
                PhotoSelect(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            } else if capsuleState == "SongSelect" {
                SongSelect(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(localCapsule)
                    .environmentObject(SpotifyManager())
            } else if capsuleState == "AnswerPrompt" {
                AnswerPrompt(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            } else if capsuleState == "AdditionalGoodies" {
                AdditionalGoodiesRouter(capsuleState: $capsuleState)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            } else if capsuleState == "SetDate" {
                SetDate(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    CapsuleRouter()
}
