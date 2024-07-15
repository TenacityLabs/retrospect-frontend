//
//  Router.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-29.
//

import SwiftUI

struct Router: View {
    @State private var state = "SealBox"
    @State private var localCapsule = capsule()
    
    var body: some View {
        ZStack {
            BackgroundImageView()
            if state == "IconSelect" {
                IconSelect(state: $state)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            } else if state == "ChooseName" {
                ChooseName(state: $state)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            } else if state == "PhotoSelect" {
                PhotoSelect(state: $state)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            } else if state == "SongSelect" {
                SongSelect(state: $state)
                    .transition(.slide)
                    .environmentObject(localCapsule)
                    .environmentObject(SpotifyManager())
            } else if state == "AnswerPrompt" {
                AnswerPrompt(state: $state)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            } else if state == "AdditionalGoodies" {
                AdditionalGoodiesRouter(state: $state)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            } else if state == "SetDate" {
                SetDate(state: $state)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            } else if state == "SealBox" {
                SealCapsuleView(state: $state)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    Router()
}
