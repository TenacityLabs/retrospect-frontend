//
//  LocalTypes.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-14.
//

import Foundation
import SwiftUI
import Combine

struct Images {
    var id: UInt?
    var uploaded: Bool = false
    var image: UIImage
    var fileURL: URL
    var fileType: String
}

struct Prompt {
    var prompt: String
    var response: String
}

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

struct PathWithColor {
    var path: UIBezierPath
    var color: UIColor
}

@MainActor class Capsule: ObservableObject {
    @Published var container: String?
    @Published var images: [Images] = []
    @Published var collab: Bool?
    @Published var prompts: [Prompt] = []
    @Published var songs: [Track] = []
    @Published var audios: [Data] = []
    @Published var files: [URL] = []
    @Published var texts: [String] = []
    @Published var drawings: [[PathWithColor]] = [[]]
    @Published var date: Date = Date()
}
