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
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            ChooseName(state: .constant(""))
//                .customText()
//        }
//    }
//}
//
//struct CustomTextModifier: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .font(.headline)
//            .foregroundColor(.white)
//            .padding()
//            .background(Color.black.opacity(0.7))
//            .cornerRadius(10)
//    }
//}
//
//extension View {
//    func customText() -> some View {
//        self.modifier(CustomTextModifier())
//    }
//}
