import SwiftUI

@main
struct RetrospectApp: App {
    @StateObject private var spotifyManager = SpotifyManager()
    @StateObject private var dataStore = DataStore()

    var body: some Scene {
        WindowGroup {
            ZStack {
                Router()
                    .background(Color.white.opacity(1.0))
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
