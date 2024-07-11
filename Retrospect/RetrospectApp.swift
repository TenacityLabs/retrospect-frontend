import SwiftUI

public var jwt = ""

@main
struct RetrospectApp: App {
    @StateObject private var spotifyManager = SpotifyManager()
    @StateObject private var dataStore = capsule()
    @State private var globalState = "Landing"

    var body: some Scene {
        WindowGroup {
            ZStack {
                BackgroundImageView()
                if globalState == "Landing" {
                    Landing(state: $globalState)
                        .transition(.slide)
                        .environmentObject(dataStore)
                } else if globalState == "Login" {
                    Login(state: $globalState)
                        .transition(.slide)
                        .environmentObject(dataStore)
                } else if globalState == "SignUp" {
                    SignUp(state: $globalState)
                        .transition(.slide)
                        .environmentObject(dataStore)
                } else if globalState == "Dashboard" {
                    Dashboard(state: $globalState)
                        .transition(.slide)
                        .environmentObject(dataStore)
                } else if globalState == "Capsule" {
                    CapsuleRouter()
                        .transition(.slide)
                        .environmentObject(dataStore)
                }
            }
        }
    }
}

struct BackgroundImageView: View {
    var body: some View {
        Image("Grains")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}
