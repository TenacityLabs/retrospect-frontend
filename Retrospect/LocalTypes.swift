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
    @Published var doodles: [[PathWithColor]] = [[]]
    @Published var songs: [Data] = []
    @Published var writings: [Data] = []
    @Published var photos: [Data] = []
    @Published var miscFiles: [Data] = []
    @Published var date: Date = Date()
}

@MainActor class User: ObservableObject {
    @Published var id: Int32? = nil
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var referralCount: Int32? = nil
    @Published var createdAt: String? = nil
}

