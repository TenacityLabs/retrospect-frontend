//
//  AdditionalGoodiesRouter.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-29.
//

import SwiftUI

struct AdditionalGoodiesRouter: View {
    @Binding var capsuleState: String
    @State private var AGstate = "AdditionalGoodies"
    @State private var drawIndex = 0
    @EnvironmentObject var dataStore: Capsule
    
    var body: some View {
        ZStack {
            if AGstate == "AdditionalGoodies" {
                AdditionalGoodies(state: $capsuleState, AGstate: $AGstate)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if AGstate == "AddText" {
                AddText(AGstate: $AGstate)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if AGstate == "AddAudio" {
                AddAudio(AGstate: $AGstate)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if AGstate == "CreateDrawing" {
                CreateDrawing(AGstate: $AGstate, drawIndex: $drawIndex)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if AGstate == "EditDrawing" {
                EditDrawing(AGstate: $AGstate, drawIndex: $drawIndex)
                    .transition(.slide)
                    .environmentObject(dataStore)
            } else if AGstate == "AddFile" {
                AddFile(AGstate: $AGstate)
                    .transition(.slide)
                    .environmentObject(dataStore)
            }
        }
    }
}

#Preview {
    AdditionalGoodiesRouter(capsuleState: .constant(""))
        .environmentObject(Capsule())
}
