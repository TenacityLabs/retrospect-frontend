import SwiftUI

struct AddText: View {
    @State private var selectedIndex: Int = 0
    @EnvironmentObject var localCapsule: Capsule
    @Binding var AGstate: String
    
    var body: some View {
        VStack {
            Text("Write Something")
                .font(.largeTitle)
                .padding(.top, 20)
            
            TabView(selection: $selectedIndex) {
                ForEach(localCapsule.texts.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack {
                            TextField("Write to your heart’s desire...", text: $localCapsule.texts[index], axis: .vertical)
                                .lineLimit(10, reservesSpace: true)
                                .padding()
                                .background(Color(UIColor.systemGray5))
                                .cornerRadius(15)
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .padding(.horizontal, 10)
                
                // Add new text button
                if localCapsule.texts.count < 3 {
                    VStack {
                        Spacer()
                        Button(action: {
                            localCapsule.texts.append("")
                            selectedIndex = localCapsule.texts.count - 1
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
                    .tag(localCapsule.texts.count)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)
            
            // Custom page control indicator
            HStack {
                ForEach(0..<localCapsule.texts.count + (localCapsule.texts.count < 3 ? 1 : 0), id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.black : Color.gray)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: selectedIndex)
                }
            }
            .padding(.top, 10)
            
            // Delete current text button
            Button(action: {
                localCapsule.texts.remove(at: selectedIndex)
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
            .opacity(localCapsule.texts.count <= 1 || selectedIndex == localCapsule.texts.count ? 0.5 : 1.0)
            .disabled(localCapsule.texts.count <= 1 || selectedIndex == localCapsule.texts.count)
            
            Button(action: {
                AGstate = "AdditionalGoodies"
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
            if localCapsule.texts.isEmpty {
                localCapsule.texts.append("") // Add an empty text if the array is empty
            }
        }
    }
}

#Preview {
    AddText(AGstate: .constant(""))
        .environmentObject(Capsule())
}
