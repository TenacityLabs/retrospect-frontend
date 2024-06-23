//
//  Capsule.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-05-24.
//

import SwiftUI
import Combine

class DataStore: ObservableObject {
    @Published var selectedIcon: Int?
    @Published var collab: Bool?
    @Published var songs: [Track] = []
    @Published var audios: [Data] = []
    @Published var files: [URL] = []
    @Published var texts: [String] = []
    @Published var drawing: Data?
}
 
