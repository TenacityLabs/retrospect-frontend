import SwiftUI

struct Collab: View {
    @EnvironmentObject var dataStore: capsule
    @State private var showSongSelectView = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Before we begin:")
                    .font(.title)
                    .padding(.top, 50) // Adjust top padding if needed
                
                Spacer()
                
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            dataStore.collab = false
                            UserDefaults.standard.set(false, forKey: "collab")
                        }) {
                            VStack {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(dataStore.collab == false ? .blue : .gray)
                                
                                Text("I'm making my capsule solo")
                                    .font(.headline)
                                    .padding(.top, 10)
                                    .foregroundColor(dataStore.collab == false ? .blue : .primary)
                            }
                            .padding()
                            .frame(width: (geometry.size.width - 80) / 2)
                            .background(dataStore.collab == false ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }

                        Button(action: {
                            dataStore.collab = true
                            UserDefaults.standard.set(true, forKey: "collab")
                        }) {
                            VStack {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(dataStore.collab == true ? .blue : .gray)
                                
                                Text("I'd like to collaborate")
                                    .font(.headline)
                                    .padding(.top, 10)
                                    .foregroundColor(dataStore.collab == true ? .blue : .primary)
                            }
                            .padding()
                            .frame(width: (geometry.size.width - 80) / 2)
                            .background(dataStore.collab == true ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .frame(height: 200) // Set an appropriate height for the GeometryReader
                Spacer()
            }
        }
    }
}

struct Collab_Previews: PreviewProvider {
    static var previews: some View {
        Collab()
            .environmentObject(capsule())
    }
}
