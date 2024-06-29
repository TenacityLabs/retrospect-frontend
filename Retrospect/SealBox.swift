//
//  SealBox.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-29.
//

import SwiftUI

struct SealBox: View {
    @Binding var state: String
    
    var body: some View {
        Text("Youre box has been sealed")
    }
}

#Preview {
    SealBox(state: .constant(""))
}
