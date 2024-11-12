//
//  OpenSummary.swift
//  Retrospect
//
//  Created by John Liu on 2024-07-15.
//

import Foundation
import SwiftUI

struct OpenSummaryScreen: View {
    var body: some View {
        VStack {
            Spacer()
            Text("how many of each item / how many you contributed (collab only)").font(.custom("Syne-Regular", size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Spacer() 
            Text("how long the capsule was closed for").font(.custom("Syne-Regular", size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Spacer()
            Text("something special (you had an audio msg that was 20 min long, that was longer than average)???").font(.custom("Syne-Regular", size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}


#Preview{
    ZStack {
        ColorImageView()
        OpenSummaryScreen()
    }
}
