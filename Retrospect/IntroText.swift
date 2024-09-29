//
//  IntroText.swift
//  Retrospect
//
//  Created by John Liu on 2024-07-15.
//

import Foundation
import SwiftUI

struct IntroText: View {
    var body: some View {
        VStack {
            Text("Introduction text needs copywrighting").font(.custom("IvyOraDisplay-Regular", size: 48))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}


#Preview{
    ZStack {
        ColorImageView()
        IntroText()
    }
}
