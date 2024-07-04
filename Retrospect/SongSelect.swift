//
//  SongSelect.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-05-24.
//

import SwiftUI

struct Track: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let artistName: String
    let albumArtURL: URL?

    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct SongSelect: View {
    @EnvironmentObject var spotifyManager: SpotifyManager
    @State private var query: String = ""
    @State private var selectedTracks: Set<Track> = []
    @EnvironmentObject var dataStore: capsule
    @Binding var state: String

    var body: some View {
        NavigationView {
            VStack {
                Text("Add Songs")
                    .font(.title)
                    .padding(.top, 20)
                    .multilineTextAlignment(.center)
                
                if spotifyManager.authorized {
                    TextField("Search for a song", text: $query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onChange(of: query) {
                            if !query.isEmpty {
                                spotifyManager.searchTracks(query: query)
                            }
                        }
                    
                    if query.isEmpty && !dataStore.songs.isEmpty {
                        SongCarouselView()
                            .environmentObject(dataStore)
                    } else {
                        List(spotifyManager.searchResults) { track in
                            HStack {
                                if let albumArtURL = track.albumArtURL {
                                    AsyncImage(url: albumArtURL) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(8)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(8)
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(8)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                }
                                VStack(alignment: .leading) {
                                    Text(track.name)
                                        .font(.headline)
                                    Text(track.artistName)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                if selectedTracks.contains(track) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if selectedTracks.contains(track) {
                                    selectedTracks.remove(track)
                                } else {
                                    selectedTracks.insert(track)
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !selectedTracks.isEmpty {
                        Button(action: {
                            query = ""
                            dataStore.songs.append(contentsOf: selectedTracks)
                            selectedTracks.removeAll()
                        }) {
                            Text("Add")
                        }
                    } else if selectedTracks.isEmpty && !dataStore.songs.isEmpty {
                        Button(action: {
                            state = "AnswerPrompt"
                        }) {
                            Text("Done")
                        }
                    } else {
                        Button(action: {}) {
                            Text("")
                                .padding()
                                .background(Color.clear)
                                .cornerRadius(8)
                        }
                        .disabled(true)
                    }
                }
            }
            .onAppear {
                if !spotifyManager.authorized {
                    spotifyManager.authorize()
                }
            }
        }
    }
}

struct SongCarouselView: View {
    @State private var allIndices: [Int] = []
    @State private var selectedIndex: Int = 0
    @EnvironmentObject var dataStore: capsule
    
    var body: some View {
        VStack {
            TabView(selection: $selectedIndex) {
                ForEach(dataStore.songs.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack {
                            if let albumArtURL = dataStore.songs[index].albumArtURL {
                                AsyncImage(url: albumArtURL) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.8)
                                            .background(Color.gray.opacity(0.3))
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.8)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.8)
                                            .background(Color.gray.opacity(0.3))
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.8)
                                    .background(Color.gray.opacity(0.3))
                            }
                            Text(dataStore.songs[index].name)
                                .font(.headline)
                            Text(dataStore.songs[index].artistName)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .scaleEffect(geometry.frame(in: .global).minX == 0 ? 1 : 0.8)
                    }
                    .padding(.horizontal, 10)
                    .tag(index) // Ensure tags are set for selection
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)
            
            // Custom page control indicator
            HStack {
                ForEach(0..<allIndices.count, id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.black : Color.gray)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: selectedIndex)
                }
            }
            .padding(.top, 10)
        }
        .frame(width: UIScreen.main.bounds.width)
        .onAppear {
            allIndices = Array(dataStore.songs.indices)
        }
    }
}

#Preview {
    SongSelect(state: .constant(""))
        .environmentObject(SpotifyManager())
        .environmentObject(capsule())
}
