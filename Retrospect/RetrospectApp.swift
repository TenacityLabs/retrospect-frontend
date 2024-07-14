import SwiftUI

public var jwt = ""

@main
struct RetrospectApp: App {
    @StateObject private var spotifyManager = SpotifyManager()
    @StateObject private var dataStore = Capsule()
    @State private var globalState = "Landing"

    var body: some Scene {
        WindowGroup {
            ZStack {
                BackgroundImageView()
                if globalState == "Landing" {
                    Landing(state: $globalState)
                        .environmentObject(dataStore)
                } else if globalState == "Login" {
                    Login(state: $globalState)
                        .environmentObject(dataStore)
                } else if globalState == "SignUp" {
                    SignUp(state: $globalState)
                        .environmentObject(dataStore)
                } else if globalState == "Tutorial" {
                    Tutorial(state: $globalState)
                        .environmentObject(dataStore)
                } else if globalState == "Dashboard" {
                    Dashboard(state: $globalState)
                        .environmentObject(dataStore)
                } else if globalState == "Capsule" {
                    CapsuleRouter()
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

struct ColorImageView: View {
    var body: some View {
        Image("grains-color")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}
