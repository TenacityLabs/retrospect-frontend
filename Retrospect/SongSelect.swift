//
//  SongSelect.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-05-24.
//

import SwiftUI

//FIXME: add styling & remove song buttons
//FIXME: add loading screen & screen for empty search bar + empty backendCapsule.songs

import SwiftUI

struct SongSelect: View {
    @State private var query: String = ""
    @EnvironmentObject var spotifyManager: SpotifyManager
    @EnvironmentObject var globalState: GlobalState
    @State private var songs: [APISong] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Add Songs")
                    .font(.title)
                    .padding(.top, 20)
                    .multilineTextAlignment(.center)
                
                if spotifyManager.authorized {
                    TextField("Search for a song", text: $query, onCommit: {
                        hideKeyboard()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: query) {
                        if !query.isEmpty {
                            spotifyManager.searchTracks(query: query)
                        }
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                hideKeyboard()
                            }
                        }
                    }
                    
                    List {
                        ForEach((query.isEmpty && !songs.isEmpty) ? songs : spotifyManager.searchResults, id: \.spotifyId) { song in
                            HStack {
                                ProgressiveSongImage(song: song)
                                VStack(alignment: .leading) {
                                    Text(song.name)
                                        .font(.headline)
                                    Text(song.artistName)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                if songs.contains(song) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                                
                                if (query.isEmpty && !songs.isEmpty) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.blue)
                                        .padding(.leading, 10)
                                        .onTapGesture {
                                            if song.uploaded {
                                                let body: [String: Any] = ["capsuleId": globalState.focusCapsule?.capsule.id, "SongId": song.id!]
                                                CapsuleAPIClient.shared.delete(authorization: globalState.jwt, mediaType: .song, body: body)
                                                {_ in}
                                            }
                                            
                                            if let index = songs.firstIndex(of: song) {
                                                songs.remove(at: index)
                                            }
                                        }
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if songs.contains(song) {
                                    if let index = songs.firstIndex(of: song) {
                                        songs.remove(at: index)
                                    }
                                } else if !songs.contains(song) {
                                    songs.append(song)
                                }
                            }
                        }
                    }
                    .onChange(of: songs) {
                        songs = Array(Set(songs))
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        globalState.focusCapsule?.songs = songs
                        uploadSongs(globalState: globalState, songArray: songs, completing: { arr, ind, newId in
                            songs[ind].id = newId
                            songs[ind].uploaded = true
                        })
                        globalState.route = "/capsule/answer-prompt"
                    }) {
                        Text("Done")
                    }
                }
            }
            .onAppear {
                if !spotifyManager.authorized {
                    spotifyManager.authorize()
                }
            }
        }
        .onAppear {
            songs = globalState.focusCapsule?.songs ?? []
        }
    }
}

struct ProgressiveSongImage: View {
    var song: APISong
    
    var body: some View {
        AsyncImage(url: URL(string: song.albumArtURL)) { phase in
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
    }
}

@MainActor func uploadSongs(globalState: GlobalState, songArray: [APISong], completing: @escaping([APISong], Int, UInt) -> Void) {
    for index in songArray.indices where !songArray[index].uploaded {
        let body: [String: Any] =
        ["capsuleId": globalState.focusCapsule?.capsule.id,
                "spotifyId": songArray[index].spotifyId,
                "name": songArray[index].name,
                "artistName": songArray[index].artistName,
                "albumArtUrl": songArray[index].albumArtURL]
        
        CapsuleAPIClient.shared.create(
            authorization: globalState.jwt,
        mediaType: .song,
        body: body) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let createResult):
                    completing(songArray, index, createResult.id)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SongSelect()
        .environmentObject(SpotifyManager())
}
