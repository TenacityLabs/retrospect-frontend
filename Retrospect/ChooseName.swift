//
//  ChooseName.swift
//  Retrospect
//
//  Created by John Liu on 2024-06-14.
//

import SwiftUI

struct ControlledInput: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .border(Color.gray, width: 1)
            .padding(.horizontal)
    }
}

struct ChooseName: View {
    var body: some View {
        Text("Choose Name")
        
    }
}

#Preview {
    ChooseName()
}

