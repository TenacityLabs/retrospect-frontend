//
//  Capsule.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-05-24.
//

import SwiftUI
import Combine

class Capsule: ObservableObject {
    @Published var container: Int?
    @Published var images: [UIImage] = []
    @Published var collab: Bool?
    @Published var prompts: [Prompt] = []
    @Published var songs: [Track] = []
    @Published var audios: [Data] = []
    @Published var files: [URL] = []
    @Published var texts: [String] = []
    @Published var drawings: [[PathWithColor]] = [[]]
}
 
