//
//  AdditionalGoodiesRouter.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-29.
//

import SwiftUI

struct AdditionalGoodiesRouter: View {
    @Binding var state: String
    @State private var AGstate = "AdditionalGoodies"
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        ZStack {
            if AGstate == "AdditionalGoodies" {
                AdditionalGoodies(state: $state, AGstate: $AGstate)
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
//            } 
//            else if AGstate == "CreateDrawing" {
//                CreateDrawing(AGstate: $AGstate)
//                    .transition(.slide)
//                    .environmentObject(dataStore)
            } else if AGstate == "AddFile" {
                AddFile(AGstate: $AGstate)
                    .transition(.slide)
                    .environmentObject(dataStore)
            }
        }
    }
}

#Preview {
    AdditionalGoodiesRouter(state: .constant(""))
        .environmentObject(DataStore())
}
