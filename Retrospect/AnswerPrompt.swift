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
    @EnvironmentObject var globalState: GlobalState
    @State private var selectedIndex: Int = 0
    @State private var prompts: [APIQuestionAnswer] = []

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
                            prompts.append(APIQuestionAnswer(uploaded: false, prompt: "What item would you bring to a deserted island?", answer: ""))
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
                    let body: [String: Any] = ["capsuleId": globalState.focusCapsule?.capsule.id, "QuestionAnswerId": prompts[selectedIndex].id!]
                    CapsuleAPIClient.shared.delete(authorization: globalState.jwt, mediaType: .prompt, body: body)
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
                globalState.focusCapsule?.questionAnswers = prompts
                uploadPrompts(globalState: globalState, qaArray: prompts, uploadCompleting: { arr, ind, newId in
                    prompts[ind].id = newId
                    prompts[ind].uploaded = true
                }, editCompleting: { arr, ind in
                    prompts[ind].uploaded = true
                    prompts[ind].edited = false
                })
                globalState.route = "/ag"
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
            prompts = globalState.focusCapsule?.questionAnswers ?? []
            if prompts.isEmpty {
                prompts.append(APIQuestionAnswer(uploaded: false, prompt: "What item would you bring to a deserted island?", answer: ""))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

@MainActor func uploadPrompts(globalState: GlobalState, qaArray: [APIQuestionAnswer], uploadCompleting: @escaping([APIQuestionAnswer], Int, UInt) -> Void, editCompleting: @escaping([APIQuestionAnswer], Int) -> Void) {
    for index in qaArray.indices where (!qaArray[index].uploaded || qaArray[index].edited) {
        
        if !qaArray[index].uploaded {
            let body: [String: Any] =
            ["capsuleId": globalState.focusCapsule?.capsule.id,
                "prompt": qaArray[index].prompt,
                "answer": qaArray[index].answer]
            
            CapsuleAPIClient.shared.create(
                authorization: globalState.jwt,
            mediaType: .prompt,
            body: body)
            { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let createResult):
                        uploadCompleting(qaArray, index, createResult.id)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else if qaArray[index].edited {
            
            let body: [String: Any] =
            ["capsuleId": globalState.focusCapsule?.capsule.id,
                 "QuestionAnswerId": qaArray[index].id!,
                "prompt": qaArray[index].prompt,
                "answer": qaArray[index].answer]
            
            CapsuleAPIClient.shared.update(
                authorization: globalState.jwt,
            updateType: .QuestionAnswer,
            body: body)
            { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let result):
                        editCompleting(qaArray, index)
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
        AnswerPrompt()
    }
}
