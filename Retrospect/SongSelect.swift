//
//  SongSelect.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-05-24.
//

import SwiftUI

//FIXME: add func to remove songs (frontend / backend) & styling & remove song buttons
//FIXME: add loading screen & screen for empty search bar + empty localCapsule.songs

struct SongSelect: View {
    @EnvironmentObject var spotifyManager: SpotifyManager
    @State private var query: String = ""
    @State private var selectedTracks: Set<Track> = []
    @EnvironmentObject var localCapsule: Capsule
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
                    
                    List {
                        ForEach((query.isEmpty && !localCapsule.songs.isEmpty) ? localCapsule.songs : spotifyManager.searchResults, id: \.songId) { track in
                            HStack {
                                AsyncImage(url: URL(string: track.albumArtURL)) { phase in
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
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                VStack(alignment: .leading) {
                                    Text(track.name)
                                        .font(.headline)
                                    Text(track.artistName)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                if selectedTracks.contains(track) || localCapsule.songs.contains(track) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if selectedTracks.contains(track) {
                                    selectedTracks.remove(track)
                                } else if !localCapsule.songs.contains(track) {
                                    selectedTracks.insert(track)
                                }
                            }
                        }
                    }
                    .onChange(of: localCapsule.songs) {
                        localCapsule.songs = Array(Set(localCapsule.songs))
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !selectedTracks.isEmpty {
                        Button(action: {
                            query = ""
                            localCapsule.songs.append(contentsOf: selectedTracks)
                            selectedTracks.removeAll()
                        }) {
                            Text("Add")
                        }
                    } else if selectedTracks.isEmpty && !localCapsule.songs.isEmpty {
                        Button(action: {
                            uploadSongs(capsule: localCapsule)
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


@MainActor func uploadSongs(capsule: Capsule) {
    for index in capsule.songs.indices {
        CapsuleAPIClient.shared.createSong(
            authorization: jwt,
            capsuleId: (backendCapsule?.capsule.id)!,
            song: capsule.songs[index])
        { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    print("Uploaded")
                    capsule.songs[index].id = result.id
                    capsule.songs[index].uploaded = true
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

#Preview {
    SongSelect(state: .constant(""))
        .environmentObject(SpotifyManager())
        .environmentObject(Capsule())
}
