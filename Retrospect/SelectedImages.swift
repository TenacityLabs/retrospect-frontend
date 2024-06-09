//
//  SelectedImages.swift
//  Retrospect
//
//  Created by John Liu on 2024-06-09.
//

import SwiftUI
import Combine

class SelectedImages: ObservableObject {
    @Published var images: [UIImage] = []
}
