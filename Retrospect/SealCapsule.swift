//
//  SealCapsule.swift
//  Retrospect
//
//  Created by John Liu on 2024-07-05.
//

import SwiftUI
import AudioToolbox

struct VibrateButtonView: View {
    var body: some View {
        VStack {
            Text("Remember this moment and capture it forever...")
                .multilineTextAlignment(.center)
            Button(action: {
                self.vibratePhone()
            }) {
                Text("Vibrate")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    private func vibratePhone() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

struct VibrateButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VibrateButtonView()
    }
}

