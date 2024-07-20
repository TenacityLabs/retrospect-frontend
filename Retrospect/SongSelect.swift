//
//  SongSelect.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-05-24.
//

import SwiftUI

//FIXME: add styling & remove song buttons
//FIXME: add loading screen & screen for empty search bar + empty backendCapsule.songs

struct SongSelect: View {
    @EnvironmentObject var spotifyManager: SpotifyManager
    @State private var query: String = ""
    @State private var songs: [Song] = backendCapsule.songs
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
                        ForEach((query.isEmpty && !songs.isEmpty) ? songs : spotifyManager.searchResults, id: \.spotifyId) { song in
                            HStack {
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
                                                let body: [String: Any] = ["capsuleId": backendCapsule.capsule.id, "SongId": song.id!]
                                                CapsuleAPIClient.shared.delete(authorization: jwt, mediaType: .song, body: body)
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
                        backendCapsule.songs = songs
                        uploadSongs()
                        state = "AnswerPrompt"
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
    }
}

@MainActor func uploadSongs() {
    for index in backendCapsule.songs.indices where !backendCapsule.songs[index].uploaded {

        let body: [String: Any] =
                ["capsuleId": backendCapsule.capsule.id,
                "spotifyId": backendCapsule.songs[index].spotifyId,
                "name": backendCapsule.songs[index].name,
                "artistName": backendCapsule.songs[index].artistName,
                "albumArtUrl": backendCapsule.songs[index].albumArtURL]
        
        CapsuleAPIClient.shared.create(
        authorization: jwt,
        mediaType: .song,
        body: body) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let result):
                        print("Uploaded")
                        backendCapsule.songs[index].id = result.id
                        backendCapsule.songs[index].uploaded = true
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
}
