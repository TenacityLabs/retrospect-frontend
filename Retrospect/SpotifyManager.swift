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
    @Published var searchResults: [Song] = []
    private var cancellables: Set<AnyCancellable> = []
    let spotify: SpotifyAPI<ClientCredentialsFlowManager>
    
    private var searchQuery = PassthroughSubject<String, Never>()
    
    init() {
        self.spotify = SpotifyAPI(
            authorizationManager: ClientCredentialsFlowManager(
                clientId: "63c675d6cfd045ba86d75d3d4e4d0613",
                clientSecret: "67e1573114bd452aa0e34a9c40f2de9e"
            )
        )
        
        searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    func authorize() {
        spotify.authorizationManager.authorize()
            .receive(on: DispatchQueue.main)
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
        searchQuery.send(query)
    }
    
    private func performSearch(query: String) {
        spotify.search(query: query, categories: [.track])
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    print(completion)
                },
                receiveValue: { [weak self] results in
                    guard let self = self else { return }
                    let tracks = results.tracks?.items.compactMap { track in
                        Song(
                            uploaded: false,
                            spotifyId: track.id ?? "",
                            name: track.name,
                            artistName: track.artists?.first?.name ?? "",
                            albumArtURL: track.album?.images?.first?.url.absoluteString ?? ""
                        )
                    } ?? []
                    self.searchResults = Array(Set(tracks))
                }
            )
            .store(in: &cancellables)
    }
}

