//import SwiftUI
//
//struct AddText: View {
//    @State private var selectedIndex: Int = 0
//    @State private var texts: [Writing] = backendCapsule.writings
//    @Binding var AGstate: String
//    
//    var body: some View {
//        VStack {
//            Text("Write Something")
//                .font(.largeTitle)
//                .padding(.top, 20)
//            
//            TabView(selection: $selectedIndex) {
//                ForEach(texts.indices, id: \.self) { index in
//                    GeometryReader { geometry in
//                        VStack {
//                            TextField("Write to your heart’s desire...", text: $texts[index].writing, axis: .vertical)
//                                .lineLimit(10, reservesSpace: true)
//                                .padding()
//                                .background(Color(UIColor.systemGray5))
//                                .cornerRadius(15)
//                                .padding(.horizontal, 20)
//                                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                .onChange(of: texts[index].writing) {
//                                    texts[index].edited = true
//                                }
//                        }
//                    }
//                }
//                .padding(.horizontal, 10)
//                
//                if texts.count < 3 {
//                    VStack {
//                        Spacer()
//                        Button(action: {
//                            texts.append(Writing(uploaded: false, writing: ""))
//                            selectedIndex = texts.count - 1
//                        }) {
//                            VStack {
//                                Image(systemName: "plus")
//                                    .resizable()
//                                    .foregroundColor(.white)
//                                    .frame(width: 30, height: 30)
//                            }
//                            .frame(width: 325, height: 250)
//                            .background(Color(UIColor.systemGray5))
//                            .cornerRadius(15)
//                            .padding(.horizontal, 20)
//                        }
//                        Spacer()
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .padding(.horizontal, 10)
//                    .tag(texts.count)
//                }
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            .frame(height: 400)
//
//            HStack {
//                ForEach(0..<texts.count + (texts.count < 3 ? 1 : 0), id: \.self) { index in
//                    Circle()
//                        .fill(index == selectedIndex ? Color.black : Color.gray)
//                        .frame(width: 8, height: 8)
//                        .animation(.easeInOut, value: selectedIndex)
//                }
//            }
//            .padding(.top, 10)
//            
//            Button(action: {
//                if texts[selectedIndex].uploaded {
//                    let body: [String: Any] = ["capsuleId": backendCapsule.capsule.id, "PhotoId": texts[selectedIndex].id!]
//                    CapsuleAPIClient.shared.delete(authorization: jwt, mediaType: .writing, body: body)
//                    {_ in}
//                }
//                
//                texts.remove(at: selectedIndex)
//                if selectedIndex != 0 {
//                    selectedIndex = selectedIndex - 1
//                }
//            }) {
//                Text("Delete Text")
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(width: 300)
//                    .background(Color.gray)
//                    .cornerRadius(25)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 25)
//                            .stroke(Color.black, lineWidth: 1)
//                    )
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 10)
//            .opacity(texts.count <= 1 || selectedIndex == texts.count ? 0.5 : 1.0)
//            .disabled(texts.count <= 1 || selectedIndex == texts.count)
//            
//            Button(action: {
//                backendCapsule.writings = texts
//                uploadTexts()
//                AGstate = "AdditionalGoodies"
//            }) {
//                Text("I'm Done!")
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(width: 300)
//                    .background(Color.gray)
//                    .cornerRadius(25)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 25)
//                            .stroke(Color.black, lineWidth: 1)
//                    )
//            }
//            .padding(.horizontal, 20)
//        }
//        .onAppear {
//            if texts.isEmpty {
//                texts.append(Writing(uploaded: false, writing: ""))
//            }
//        }
//    }
//}
//
//@MainActor func uploadTexts() {
//    for index in backendCapsule.writings.indices where (!backendCapsule.writings[index].uploaded || backendCapsule.writings[index].edited) {
//        
//        if !backendCapsule.writings[index].uploaded {
//            let body: [String: Any] =
//                    ["capsuleId": backendCapsule.capsule.id,
//                     "writing": backendCapsule.writings[index].writing]
//            
//            CapsuleAPIClient.shared.create(
//            authorization: jwt,
//            mediaType: .writing,
//            body: body)
//            { result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let result):
//                        print("Uploaded")
//                        backendCapsule.writings[index].id = result.id
//                        backendCapsule.writings[index].uploaded = true
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//            }
//        } else if backendCapsule.writings[index].edited {
//            let body: [String: Any] =
//                    ["capsuleId": backendCapsule.capsule.id,
//                     "writingId": backendCapsule.writings[index].id!,
//                     "writing": backendCapsule.writings[index].writing]
//            
//            CapsuleAPIClient.shared.update(
//            authorization: jwt,
//            updateType: .Writing,
//            body: body)
//            { result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(_):
//                        backendCapsule.writings[index].uploaded = true
//                        backendCapsule.writings[index].edited = false
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//            }
//
//        }
//    }
//}
//
//#Preview {
//    AddText(AGstate: .constant(""))
//        .environmentObject(Capsule())
//}
