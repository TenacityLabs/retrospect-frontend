//
//  SpotifyManager.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-05-26.
//

import Foundation
import Combine
import SpotifyWebAPI

class SpotifyManager: ObservableObject {
    @Published var authorized = false
    @Published var searchResults: [Track] = []
    private var cancellables: Set<AnyCancellable> = []
    let spotify: SpotifyAPI<ClientCredentialsFlowManager>
    
    init() {
        self.spotify = SpotifyAPI(
            authorizationManager: ClientCredentialsFlowManager(
                clientId: "63c675d6cfd045ba86d75d3d4e4d0613",
                clientSecret: "67e1573114bd452aa0e34a9c40f2de9e"
            )
        )
    }
    
    func authorize() {
        spotify.authorizationManager.authorize()
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        print("successfully authorized application")
                        self.authorized = true
                    case .failure(let error):
                        print("could not authorize application: \(error)")
                        self.authorized = false
                }
            })
            .store(in: &cancellables)
    }
    
    func searchTracks(query: String) {
        spotify.search(query: query, categories: [.track])
            .sink(
                receiveCompletion: { completion in
                    print(completion)
                },
                receiveValue: { results in
                    self.searchResults = results.tracks?.items.compactMap { track in
                        Track(
                            id: track.id ?? "",
                            name: track.name,
                            artistName: track.artists?.first?.name ?? "",
                            albumArtURL: track.album?.images?.first?.url
                        )
                    } ?? []
                }
            )
            .store(in: &cancellables)
    }
}

