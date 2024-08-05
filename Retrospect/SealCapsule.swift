import SwiftUI
import AudioToolbox

struct SealCapsuleView: View {
    @EnvironmentObject var globalState: GlobalState
    @GestureState private var isDetectingLongPress = false
    @State private var completedLongPress = false

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 3)
            .updating($isDetectingLongPress) { currentState, gestureState, transaction in
                gestureState = currentState
            }
            .onEnded { finished in
                CapsuleAPIClient.shared.sealCapsule(authorization: globalState.jwt, capsuleId: 0, dateToOpen: globalState.localCapsule.openDate) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success():
                            completedLongPress = true
                        case .failure(_):
                            completedLongPress = true
                        }
                    }
                }
            }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                VStack {
                    Spacer()
                    Text("Jessica's Capsule has been sealed!")
                        .font(.custom("IvyOraDisplay-Regular", size: 48))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Image("box")
                        .resizable()
                        .frame(width: 300, height: 300, alignment: .center)
                    Spacer()
                    Text(globalState.localCapsule.openDate != nil ? formattedDate(globalState.localCapsule.openDate) : "Date text here")
                        .foregroundColor(Color.white)
                        .font(.custom("Syne-Regular", size: 20))
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button(action: {
                        UserAPIClient.shared.getUser(authorization: globalState.jwt)
                        { userResult in
                            DispatchQueue.main.async {
                                switch(userResult) {
                                case .success (let user):
                                    CapsuleAPIClient.shared.getCapsules(authorization: globalState.jwt)
                                    { capsuleResult in
                                        DispatchQueue.main.async {
                                            switch(capsuleResult) {
                                            case .success (let capsuleArray):
                                                globalState.user = user.user
                                                globalState.userCapsules = capsuleArray
                                                globalState.route = "/dashboard"
                                                globalState.reveal()
                                            case .failure(_):
                                                print("Capsule fetch failed, please try again!")
                                            }
                                        }
                                    }
                                case .failure(_):
                                    print("User fetch failed, please try again!")
                                }
                            }
                        }
                    }) {
                        Text("Back to collection")
                            .foregroundColor(Color.black)
                            .padding()
                            .frame(width: 300)
                            .background(Color.white)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    Spacer()
                }
                .frame(height: geometry.size.height)
                .offset(y: completedLongPress ? 0 : -geometry.size.height)
                VStack {
                    Spacer()
                    Text("Remember this moment and capture it forever...")
                        .font(.custom("IvyOraDisplay-Regular", size: 48))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Image("box")
                        .resizable()
                        .scaleEffect(self.isDetectingLongPress ? 1.1 : 0.9)
                        .shadow(color: .white, radius: self.isDetectingLongPress ? 40 : 20, x: 0, y: 0)
                        .rotationEffect(Angle(degrees: self.isDetectingLongPress ? 5 : 0))
                        .animation(self.isDetectingLongPress ? Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true) : .default, value: self.isDetectingLongPress)
                        .frame(width: 200, height: 200, alignment: .center)
                        .gesture(longPress)
                    Spacer()
                    Text("Long press to seal your capsule")
                        .foregroundColor(Color.white)
                        .font(.custom("Syne-Regular", size: 20))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .frame(height: geometry.size.height)
                .offset(y: completedLongPress ? 0 : -geometry.size.height)
            }
        }
        .padding()
    }

    private func vibratePhone() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

struct SealCapsuleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundImageView()
            SealCapsuleView()
        }
    }
}
