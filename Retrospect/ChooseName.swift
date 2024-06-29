//
//  ChooseName.swift
//  Retrospect
//
//  Created by John Liu on 2024-06-14.
//

import SwiftUI

struct ChooseName: View {
    @State private var name: String = ""
    @State private var selectedDate: Date = Date()
    @Binding var state: String
        
    var body: some View {
        VStack {
            Text("Choose Name").font(.system(size: 18))
            TextField("Name", text: $name)
            DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
            Button(action: {
                state = "SealBox"
            }) {
                Text("Done")
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
//        BackgroundImageView()
        ChooseName(state: .constant(""))
    }
}

