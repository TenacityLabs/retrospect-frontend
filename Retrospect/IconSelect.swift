import SwiftUI

struct IconSelect: View {
    @EnvironmentObject var globalState: GlobalState
    @State private var containers = ["box", "suitcase", "guitar", "jar", "shoe"]
    @State private var selectedIndex: Int = 0
    
    func reapplySelection() -> Int {
        if let index = containers.firstIndex(where: { item in
            item == globalState.localCapsule.vessel
        }) {
            return index
        } else {
            return 0
        }
    }
    
    var body: some View {
        VStack {
            Text("Pick a vessel, any vessel")
                .font(.custom("IvyOra Display", size: 48))
                .multilineTextAlignment(.center)
                .padding(.top, 80)
                .foregroundColor(.white)
            
            Spacer()
            
            TabView(selection: $selectedIndex) {
                ForEach(containers.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack {
                            Image(containers[index])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .padding()
                                .shadow(color: .white, radius: 30, x: 0, y: 0)
                        }
                        .padding()
                        .background(Color(red: 44/255, green: 44/255, blue: 44/255).opacity(0.9))
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .inset(by: 0.5)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 10)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)
            
            HStack {
                ForEach(containers.indices, id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.white : Color.white.opacity(0.1))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: selectedIndex)
                }
            }
            .padding(.top, 10)
            Spacer()
            
            Button(action: {
                globalState.route = "/capsule/choose-name"
            }) {
                Text("Confirm Selection")
                    .foregroundColor(Color.black)
                    .padding()
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            .padding(.bottom, 80)
        }
        .padding(.horizontal)
        .onAppear {
            selectedIndex = reapplySelection()
        }
        .onChange(of: selectedIndex) { newIndex in
            globalState.localCapsule.vessel = containers[newIndex]
        }
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        IconSelect().environmentObject(GlobalState())
    }
}
