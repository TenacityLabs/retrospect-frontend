//
//  AnswerPrompt.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-14.
//

import SwiftUI
import Combine

// FIXME: Fix styling, plus button wrong shape, prompt generation, prompt changing

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}

struct AnswerPrompt: View {
    @EnvironmentObject var localCapsule: Capsule
    @State private var selectedIndex: Int = 0
    @State private var prompts: [QuestionAnswer] = backendCapsule.questionAnswers
    @Binding var state: String

    var body: some View {
        VStack {
            Text("Let's get personal!")
                .font(.custom("IvyOra Display", size: 48))
                .foregroundColor(.white)
                .padding(.top, 80)

            TabView(selection: $selectedIndex) {
                ForEach(prompts.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack {
                            VStack {
                                Text(prompts[index].prompt)
                                    .font(.custom("Syne-Regular", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)

                                Spacer()
                                    .frame(height: 30)

                                HStack {
                                    TextField("", text: $prompts[index].answer.max(100))
                                        .frame(height: 45)
                                        .padding(.horizontal, 20)
                                        .background(Color(red: 44/255, green: 44/255, blue: 44/255).opacity(0.9))
                                        .cornerRadius(50)
                                        .foregroundColor(.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 50)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                        .onChange(of: prompts[index].answer) {
                                            prompts[index].edited = true
                                        }
                                }
                                .padding(.horizontal, 20)
                            }
                            .frame(width: geometry.size.width - 60, height: 160)
                            .padding()
                            .background(Color(red: 30/255, green: 30/255, blue: 30/255).opacity(0.9))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .inset(by: 0.5)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }
                }

                if prompts.count < 3 {
                    VStack {
                        Button(action: {
                            prompts.append(QuestionAnswer(uploaded: false, prompt: "What item would you bring to a deserted island?", answer: ""))
                            selectedIndex = prompts.count - 1
                        }) {
                            VStack {
                                Image(systemName: "plus")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                            }
                            .frame(width: 200, height: 200)
                            .background(Color(red: 30/255, green: 30/255, blue: 30/255).opacity(0.9))
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .inset(by: 0.5)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(prompts.count)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)

            HStack {
                ForEach(0..<prompts.count + (prompts.count < 3 ? 1 : 0), id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.white : Color.gray)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: selectedIndex)
                }
            }
            .padding(.top, 10)

            Button(action: {
                if prompts[selectedIndex].uploaded {
                    let body: [String: Any] = ["capsuleId": backendCapsule.capsule.id, "QuestionAnswerId": prompts[selectedIndex].id!]
                    CapsuleAPIClient.shared.delete(authorization: jwt, mediaType: .prompt, body: body)
                    {_ in}
                }
                
                prompts.remove(at: selectedIndex)
                if selectedIndex != 0 {
                    selectedIndex -= 1
                }
            }) {
                Text("Delete Text")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .opacity(prompts.count < 1 || selectedIndex == prompts.count ? 0.5 : 1.0)
            .disabled(prompts.count < 1 || selectedIndex == prompts.count)

            Button(action: {
                backendCapsule.questionAnswers = prompts
                uploadPrompts()
                state = "AdditionalGoodies"
            }) {
                Text("I'm Done!")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
        }
        .onAppear {
            if prompts.isEmpty {
                prompts.append(QuestionAnswer(uploaded: false, prompt: "What item would you bring to a deserted island?", answer: ""))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

@MainActor func uploadPrompts() {
    for index in backendCapsule.questionAnswers.indices where (!backendCapsule.questionAnswers[index].uploaded || backendCapsule.questionAnswers[index].edited) {
        
        if !backendCapsule.questionAnswers[index].uploaded {
            
            let body: [String: Any] =
                ["capsuleId": backendCapsule.capsule.id,
                "prompt": backendCapsule.questionAnswers[index].prompt,
                "answer": backendCapsule.questionAnswers[index].answer]
            
            CapsuleAPIClient.shared.create(
            authorization: jwt,
            mediaType: .prompt,
            body: body)
            { result in
                DispatchQueue.main.async {
                    switch result {
                        
                        case .success(let result):
                            backendCapsule.questionAnswers[index].id = result.id
                            backendCapsule.questionAnswers[index].uploaded = true
                        
                        case .failure(let error):
                            print(error)
                        
                    }
                }
            }
        } else if backendCapsule.questionAnswers[index].edited {
            
            let body: [String: Any] =
                ["capsuleId": backendCapsule.capsule.id,
                 "QuestionAnswerId": backendCapsule.questionAnswers[index].id!,
                "prompt": backendCapsule.questionAnswers[index].prompt,
                "answer": backendCapsule.questionAnswers[index].answer]
            
            CapsuleAPIClient.shared.update(
            authorization: jwt,
            updateType: .QuestionAnswer,
            body: body)
            { result in
                DispatchQueue.main.async {
                    switch result {
                        
                    case .success(let result):
                        backendCapsule.questionAnswers[index].uploaded = true
                        backendCapsule.questionAnswers[index].edited = false
                        
                    case .failure(let error):
                        print(error)
                        
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        AnswerPrompt(state: .constant(""))
            .environmentObject(Capsule())
    }
}
