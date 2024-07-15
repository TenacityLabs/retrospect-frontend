//
//  CapsuleRouter.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-07.
//

import SwiftUI

<<<<<<< HEAD:Retrospect/CapsuleRouter.swift
struct CapsuleRouter: View {
    @State private var capsuleState = "IconSelect"
=======
struct Router: View {
    @State private var state = "SealBox"
>>>>>>> refs/remotes/origin/main:Retrospect/Router.swift
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
<<<<<<< HEAD:Retrospect/CapsuleRouter.swift
            } else if capsuleState == "SetDate" {
                SetDate(state: $capsuleState)
=======
            } else if state == "SetDate" {
                SetDate(state: $state)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            } else if state == "SealBox" {
                SealCapsuleView(state: $state)
>>>>>>> refs/remotes/origin/main:Retrospect/Router.swift
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
