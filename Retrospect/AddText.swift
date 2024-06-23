//
//  AddText.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-22.
//

import SwiftUI

struct AddText: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var enteredTexts: [String] = []

    var body: some View {
        VStack {
            Text("Write sum")
                .font(.largeTitle)
                .padding()

            ScrollView {
                VStack {
                    ForEach(0..<enteredTexts.count, id: \.self) { index in
                        TextField("Enter text here", text: Binding(
                            get: { self.enteredTexts[index] },
                            set: { self.enteredTexts[index] = $0; self.dataStore.texts[index] = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    }

                    if enteredTexts.count < 10 {
                        Button(action: addTextField) {
                            Image(systemName: "plus")
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                }
            }

            Spacer()
        }
        .padding()
        .onAppear {
            enteredTexts = dataStore.texts
        }
    }

    private func addTextField() {
        if enteredTexts.count < 10 {
            enteredTexts.append("")
            dataStore.texts.append("")
        }
    }
}

#Preview {
    AddText()
        .environmentObject(DataStore())
}
