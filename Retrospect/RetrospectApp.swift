import SwiftUI

@main
struct RetrospectApp: App {
    @StateObject private var spotifyManager = SpotifyManager()
    @StateObject private var dataStore = DataStore()
    @StateObject private var selectedImages = SelectedImages()

    var body: some Scene {
        WindowGroup {
            ZStack {
                BackgroundImageView()
                LandingPage()
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

struct ContentView: View {
    var body: some View {
        VStack {
            ChooseName()
                .customText()
        }
    }
}

struct CustomTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(10)
    }
}

extension View {
    func customText() -> some View {
        self.modifier(CustomTextModifier())
    }
}
