////
////  AnswerPrompt.swift
////  Retrospect
////
////  Created by Andrew Durnford on 2024-06-14.
////
//
import SwiftUI
import Combine

// FIXME: Fix styling, plus button wrong shape, prompt generation, prompt changing

struct AddText: View {
    @EnvironmentObject var globalState: GlobalState
    @State private var selectedIndex: Int = 0
    @State private var texts: [APIWriting] = []

    var body: some View {
        VStack {
            Text("Write Something")
                .font(.largeTitle)
                .padding(.top, 20)

            TabView(selection: $selectedIndex) {
                ForEach(texts.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack {
                            TextField("Write to your heart’s desire...", text: $texts[index].writing, axis: .vertical)
                                .lineLimit(10, reservesSpace: true)
                                .padding()
                                .background(Color(UIColor.systemGray5))
                                .cornerRadius(15)
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .onChange(of: texts[index].writing) { newValue in
                                    texts[index].edited = true
                                }
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("Done") {
                                            hideKeyboard()
                                        }
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 10)

                if texts.count < 3 {
                    VStack {
                        Spacer()
                        Button(action: {
                            texts.append(APIWriting(uploaded: false, writing: ""))
                            selectedIndex = texts.count - 1
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
                    .tag(texts.count)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)

            HStack {
                ForEach(0..<texts.count + (texts.count < 3 ? 1 : 0), id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.black : Color.gray)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: selectedIndex)
                }
            }
            .padding(.top, 10)

            Button(action: {
                if texts[selectedIndex].uploaded {
                    let body: [String: Any] = ["capsuleId": globalState.focusCapsule?.capsule.id, "PhotoId": texts[selectedIndex].id!]
                    CapsuleAPIClient.shared.delete(authorization: globalState.jwt, mediaType: .writing, body: body)
                    {_ in}
                }

                texts.remove(at: selectedIndex)
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
            .opacity(texts.count <= 1 || selectedIndex == texts.count ? 0.5 : 1.0)
            .disabled(texts.count <= 1 || selectedIndex == texts.count)

            Button(action: {
                globalState.focusCapsule?.writings = texts
                uploadTexts(globalState: globalState, textArray: texts, uploadCompleting: { arr, ind, newId in
                    texts[ind].id = newId
                    texts[ind].uploaded = true
                }, editCompleting: { arr, ind in
                    texts[ind].uploaded = true
                    texts[ind].edited = false
                })
                globalState.route = "/ag"
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
            texts = globalState.focusCapsule?.writings ?? []
            if texts.isEmpty {
                texts.append(APIWriting(uploaded: false, writing: ""))
            }
        }
    }
}
@MainActor func uploadTexts(globalState: GlobalState, textArray: [APIWriting], uploadCompleting: @escaping ([APIWriting], Int, UInt) -> Void, editCompleting: @escaping ([APIWriting], Int) -> Void) {
    for index in textArray.indices where (!textArray[index].uploaded || textArray[index].edited) {
        
        if !textArray[index].uploaded {
            let body: [String: Any] =
            ["capsuleId": globalState.focusCapsule?.capsule.id,
                     "writing": textArray[index].writing]
            
            CapsuleAPIClient.shared.create(
                authorization: globalState.jwt,
            mediaType: .writing,
            body: body)
            { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let result):
                        uploadCompleting(textArray, index, result.id)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else if textArray[index].edited {
            let body: [String: Any] =
            ["capsuleId": globalState.focusCapsule?.capsule.id,
                     "writingId": textArray[index].id!,
                     "writing": textArray[index].writing]
            
            CapsuleAPIClient.shared.update(
                authorization: globalState.jwt,
            updateType: .Writing,
            body: body)
            { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        editCompleting(textArray, index)
                    case .failure(let error):
                        print(error)
                    }
                }
            }

        }
    }
}

#Preview {
    AddText()
}
