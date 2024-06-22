//
//  AnswerPrompt.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-14.
//

import SwiftUI

struct AnswerPrompt: View {
    @State private var response: String = ""
    @State private var prompt: String = "What item would you bring to a deserted island?"

    
    var body: some View {
        VStack {
            Text(prompt)
                .padding(.bottom, 20)
            
            Button(action: changePrompt) {
                Text("New Prompt")
                    .padding(.bottom, 20)
            }

            TextField("Enter your response", text: $response)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
    func changePrompt() {
        prompt = "What would you do if you won the lottery?"
    }
}

#Preview {
    AnswerPrompt()
}
