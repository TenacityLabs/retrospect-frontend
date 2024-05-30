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
    @EnvironmentObject var dataStore: DataStore

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
                            spotifyManager.searchTracks(query: query)
                        }
                    
                    List(spotifyManager.searchResults) { track in
                        HStack {
                            if let albumArtURL = track.albumArtURL {
                                AsyncImage(url: albumArtURL) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
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
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !selectedTracks.isEmpty {
                        Button(action: {
                            dataStore.songs.append(contentsOf: selectedTracks)
                            selectedTracks.removeAll()
                        }) {
                            Text("Add")
                        }
                    } else if selectedTracks.isEmpty && !dataStore.songs.isEmpty {
                        NavigationLink(destination: {
                            PhotoSelect()
                                .environmentObject(dataStore)
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

#Preview {
    SongSelect()
        .environmentObject(SpotifyManager())
        .environmentObject(DataStore())
}

