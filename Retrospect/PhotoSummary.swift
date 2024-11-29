//
//  PhotoSummary.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-11-10.
//

import SwiftUI

struct PhotoSummary: View {
    let files: [File]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                    .frame(height: 40)

                // Title section
                HStack {
                    Text("Photos from")
                        .foregroundColor(.white)
                        .font(.custom("Syne", size: 24))
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack {
                    Image("box")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 10)
                    Text("Jessica's Box")
                        .foregroundColor(.white)
                        .font(.custom("IvyOraDisplay-RegularItalic", size: 36))
                    Spacer()
                }
                .padding(.horizontal)
                
                // Dynamically display images from the `files` array
                ForEach(0..<min(files.count, 6), id: \.self) { index in
                    if let url = URL(string: files[index].fileURL),
                       let imageData = try? Data(contentsOf: url),
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: [150, 125, 115, 120, 120, 150][index], height: [150, 125, 115, 120, 120, 150][index])
                            .rotationEffect([.degrees(-15), .degrees(5), .degrees(-5), .degrees(10), .degrees(10), .degrees(-5)][index])
                            .position(x: [geometry.size.width / 4,
                                          geometry.size.width * 2.9 / 4,
                                          geometry.size.width * 0.25,
                                          geometry.size.width * 0.7,
                                          geometry.size.width * 0.2,
                                          geometry.size.width * 0.65][index],
                                      y: [geometry.size.height / 8 - 25, 0, 50, -50, 0, -75][index])
                    }
                }
                
                Spacer()
                
                // Footer section
                HStack(alignment: .lastTextBaseline) {
                    Image("Logo White")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 10)
                    
                    Text("Retrospect")
                        .foregroundColor(.white)
                        .font(.custom("IvyOra Display", size: 24))
                    
                    Spacer()
                    
                    Text("retrospect.space")
                        .foregroundColor(.white)
                        .font(.custom("Syne", size: 18))
                }
                .padding(.horizontal)
            }
            .frame(width: geometry.size.width - 40, height: geometry.size.height - 80)
            .padding()
        }
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        PhotoSummary(files: [
            File(id: 1, fileURL: "https://www.slimescholars.com/assets/secrets/el%20fizzo.png"),
            File(id: 2, fileURL: "https://www.slimescholars.com/assets/secrets/el%20fizzo.png"),
            File(id: 3, fileURL: "https://www.slimescholars.com/assets/secrets/el%20fizzo.png"),
            File(id: 4, fileURL: "https://www.slimescholars.com/assets/secrets/el%20fizzo.png"),
            File(id: 5, fileURL: "https://www.slimescholars.com/assets/secrets/el%20fizzo.png"),
            File(id: 6, fileURL: "https://www.slimescholars.com/assets/secrets/el%20fizzo.png")
        ])
    }
}
