//
//  RetrospectApp.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-05-23.
//

import SwiftUI

@main
struct RetrospectApp: App {
    @StateObject private var spotifyManager = SpotifyManager()
    @StateObject private var dataStore = DataStore()
    @StateObject private var selectedImages = SelectedImages()
    
    var body: some Scene {
        WindowGroup {
            PhotoSelect()
                .environmentObject(dataStore)
                .environmentObject(selectedImages)
        }
    }
}
