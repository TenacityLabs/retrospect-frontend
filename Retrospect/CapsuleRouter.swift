import SwiftUI

public var capsuleID: UInt?
public var backendCapsule: APICapsule = APICapsule()
public var vessel: String = "box"
public var collab: Bool = false
public var capsuleName: String = ""
public var openDate: Date?

struct CapsuleRouter: View {
    @State private var capsuleState = "IconSelect"
    @StateObject private var localCapsule = Capsule()

    var body: some View {
        ZStack {
            if capsuleState == "IconSelect" {
                IconSelect(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            } else if capsuleState == "Collab" {
                Collab(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            } else if capsuleState == "Preparing" {
                Preparing(state: $capsuleState)
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
            } else if capsuleState == "SealBox" {
                SealCapsuleView(state: $capsuleState)
                    .transition(.slide)
                    .environmentObject(localCapsule)
            }
            if !["IconSelect", "Preparing", "AdditionalGoodies"].contains(capsuleState) {
                BackButton(action: {
                    if capsuleState == "ChooseName"{
                        capsuleState = "IconSelect"
                    }
                    else if capsuleState == "Collab" {
                        capsuleState = "ChooseName"
                    }
                    else if capsuleState == "PhotoSelect" {
                        capsuleState = "ChooseName"
                    }
                    else if capsuleState == "SongSelect" {
                        capsuleState = "PhotoSelect"
                    }
                    else if capsuleState == "AnswerPrompt" {
                        capsuleState = "SongSelect"
                    }
                    else if capsuleState == "SetDate" {
                        capsuleState = "AdditionalGoodies"
                    }
                    else if capsuleState == "SealBox" {
                        capsuleState = "SetDate"
                    }
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        CapsuleRouter()
    }
}
