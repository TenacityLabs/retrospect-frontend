//
//  LocalTypes.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-14.
//

import Foundation
import SwiftUI
import Combine

struct PathWithColor {
    var path: UIBezierPath
    var color: UIColor
}

@MainActor class Capsule: ObservableObject {
    @Published var container: String = "box"
    @Published var collab: Bool?
    @Published var audios: [Data] = []
    @Published var drawings: [[PathWithColor]] = [[]]
    @Published var date: Date = Date()
}
