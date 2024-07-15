import SwiftUI

public var jwt = ""

@main
struct RetrospectApp: App {
    @StateObject private var spotifyManager = SpotifyManager()
    @StateObject private var localCapsule = Capsule()
    @State private var globalState = "Landing"

    var body: some Scene {
        WindowGroup {
            ZStack {
                BackgroundImageView()
                if globalState == "Landing" {
                    Landing(state: $globalState)
                        .environmentObject(localCapsule)
                } else if globalState == "Login" {
                    Login(state: $globalState)
                        .environmentObject(localCapsule)
                } else if globalState == "SignUp" {
                    SignUp(state: $globalState)
                        .environmentObject(localCapsule)
                } else if globalState == "Tutorial" {
                    Tutorial(state: $globalState)
                        .environmentObject(localCapsule)
                } else if globalState == "Dashboard" {
                    Dashboard(state: $globalState)
                        .environmentObject(localCapsule)
                } else if globalState == "Capsule" {
                    CapsuleRouter()
                        .environmentObject(localCapsule)
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

struct ColorImageView: View {
    var body: some View {
        Image("grains-color")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}
