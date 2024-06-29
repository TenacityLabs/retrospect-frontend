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
        
        var body: some View {
            VStack {
                Text("Choose Name").font(.system(size: 18))
                TextField("Name", text: $name)
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }.padding(.horizontal, 20)
        }
}

#Preview {
    ZStack {
        BackgroundImageView()
        ChooseName()
    }
}

