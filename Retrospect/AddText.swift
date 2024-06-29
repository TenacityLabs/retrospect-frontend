import SwiftUI

struct AddText: View {
    @State private var selectedIndex: Int = 0
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        VStack {
            Text("Write Something")
                .font(.largeTitle)
                .padding(.top, 20)
            
            TabView(selection: $selectedIndex) {
                ForEach(dataStore.texts.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack {
                            TextField("Write to your heart’s desire...", text: $dataStore.texts[index], axis: .vertical)
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
                if dataStore.texts.count < 3 {
                    VStack {
                        Spacer()
                        Button(action: {
                            dataStore.texts.append("")
                            selectedIndex = dataStore.texts.count - 1
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
                    .tag(dataStore.texts.count)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)
            
            // Custom page control indicator
            HStack {
                ForEach(0..<dataStore.texts.count + (dataStore.texts.count < 3 ? 1 : 0), id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.black : Color.gray)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: selectedIndex)
                }
            }
            .padding(.top, 10)
            
            // Delete current text button
            Button(action: {
                dataStore.texts.remove(at: selectedIndex)
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
            .opacity(dataStore.texts.count <= 1 || selectedIndex == dataStore.texts.count ? 0.5 : 1.0)
            .disabled(dataStore.texts.count <= 1 || selectedIndex == dataStore.texts.count)
            
            // FIXME: action: go back to additional goodies
            Button(action: {
                
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
            if dataStore.texts.isEmpty {
                dataStore.texts.append("") // Add an empty text if the array is empty
            }
        }
    }
}

#Preview {
    AddText()
        .environmentObject(DataStore())
}
