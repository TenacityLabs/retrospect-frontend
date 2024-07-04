//
//  AnswerPrompt.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-14.
//

import SwiftUI

struct Prompt {
    var prompt: String
    var response: String
}

// FIXME: Fix styling, delete text kind of buggy, plus button wrong shape, prompt generation, prompt changing
struct AnswerPrompt: View {
    @EnvironmentObject var dataStore: capsule
    @State private var selectedIndex: Int = 0
    @Binding var state: String
    
    var body: some View {
        VStack {
            Text("Let's get personal!")
                .font(.largeTitle)
                .padding(.top, 10)
            
            Spacer()
            
            TabView(selection: $selectedIndex) {
                ForEach(dataStore.prompts.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack {
                            VStack(spacing: 20) {
                                Text(dataStore.prompts[index].prompt)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 20)
                                        
                                        HStack {
                                            TextField("", text: $dataStore.prompts[index].response)
                                                .padding()
                                                .background(Color(.systemGray6))
                                                .cornerRadius(8)
                                                .foregroundColor(.black)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                                                )
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                    .padding()
                                    .background(Color(UIColor.systemGray5))
                                    .edgesIgnoringSafeArea(.all)
                                    .cornerRadius(15)
                        }
                    }
                }
                .padding(.horizontal, 10)
                
                // Add new text button
                if dataStore.prompts.count < 3 {
                    VStack {
                        Button(action: {
                            let newPrompt = Prompt(prompt: "What item would you bring to a deserted island?", response: "")
                            dataStore.prompts.append(newPrompt)
                            selectedIndex = dataStore.prompts.count - 1
                        }) {
                            VStack {
                                Image(systemName: "plus")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                            }
                            .frame(width: 325, height: 250)
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(15)
                            .padding(.horizontal, 20)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 10)
                    .tag(dataStore.prompts.count)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)
            
            // Custom page control indicator
            HStack {
                ForEach(0..<dataStore.prompts.count + (dataStore.prompts.count < 3 ? 1 : 0), id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.black : Color.gray)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: selectedIndex)
                }
            }
            .padding(.top, 10)
            
            // Delete current text button
            Button(action: {
                dataStore.prompts.remove(at: selectedIndex)
                if selectedIndex != 0 {
                    selectedIndex = selectedIndex - 1
                }
            }) {
                Text("Delete Text")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300)
                    .background(Color.gray)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .opacity(dataStore.prompts.count <= 1 || selectedIndex == dataStore.prompts.count ? 0.5 : 1.0)
            .disabled(dataStore.prompts.count <= 1 || selectedIndex == dataStore.prompts.count)
            
            Button(action: {
                state = "AdditionalGoodies"
            }) {
                Text("I'm Done!")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300)
                    .background(Color.gray)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            if dataStore.prompts.isEmpty {
                let newPrompt = Prompt(prompt: "What item would you bring to a deserted island?", response: "")
                dataStore.prompts.append(newPrompt)
            }
        }
    }
}

#Preview {
    AnswerPrompt(state: .constant(""))
        .environmentObject(capsule())
}
