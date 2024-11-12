//
//  OpenPhotos.swift
//  Retrospect
//
//  Created by John Liu on 2024-07-15.
//

import Foundation
import SwiftUI

extension View {
    func applyPositionIfNeeded(x: CGFloat?, y: CGFloat?) -> some View {
        Group {
            if let x = x, let y = y {
                self.position(x: x, y: y)
            } else if let x = x {
                self.position(x: x)
            } else if let y = y {
                self.position(y : y)
            } else {
                self
            }
        }
    }
}

struct OpenPhotos: View {
    let files: [File] = [
        File(id: 1, fileURL: "https://www.slimescholars.com/assets/secrets/el%20fizzo.png"),
    ]
    
    func FramedImage(url: URL, rotation: Double, size: CGFloat, opacity: CGFloat, x: CGFloat? = nil, y: CGFloat? = nil) -> some View {
        return AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: size, height: size)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .cornerRadius(10)
                    .clipped()
                    .padding(15)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    .rotationEffect(.degrees(rotation))
                    .opacity(opacity)
                    .applyPositionIfNeeded(x: x, y: y)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .cornerRadius(10)
                    .padding(15)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    .rotationEffect(.degrees(rotation))
                    .opacity(opacity)
                    .applyPositionIfNeeded(x: x, y: y)
            @unknown default:
                EmptyView()
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Top Section
                    ZStack {
                        Text("✨")
                            .font(.custom("Syne-Regular", size: 56))
                            .position(x: geometry.size.width - 80, y: 120)
                        if files.count > 2 {
                            if let url = URL(string: files[2].fileURL) {
                                FramedImage(url: url, rotation: -15, size: geometry.size.width / 2, opacity: 0.7, x: geometry.size.width - 50, y: 300)
                            }
                        }
                        if files.count > 3 {
                            if let url = URL(string: files[3].fileURL) {
                                FramedImage(url: url, rotation: -10, size: geometry.size.width / 2 - 20, opacity: 0.55, x: geometry.size.width - 100, y: geometry.size.height - 150)
                            }
                        }
                        Image(systemName: "arrow.down")
                            .font(.system(size: 56))
                            .foregroundColor(.white)
                            .position(x: geometry.size.width - 75, y: geometry.size.height - 250)
                        VStack {
                            Spacer()
                            if files.count > 0 {
                                if let url = URL(string: files[0].fileURL) {
                                    FramedImage(url: url, rotation: 20, size: geometry.size.width / 2 - 10, opacity: 0.6, x: 100)
                                }
                            }
                            VStack(alignment: .leading, spacing: 0) {
                                Text("\(files.count)")
                                    .font(.custom("Syne-Bold", size: 60))
                                    .foregroundColor(.white)
                                    .bold()
                                Text("botos")
                                    .font(.custom("IvyOraDisplay-Regular", size: 48))
                                    .foregroundColor(.white)
                                Text("binted")
                                    .font(.custom("IvyOraDisplay-Regular", size: 48))
                                    .foregroundColor(.white)
                            }.position(x: 80)
                            Spacer().frame(height: 50)
                            if files.count > 1 {
                                if let url = URL(string: files[1].fileURL) {
                                    FramedImage(url: url, rotation: 10, size: geometry.size.width / 2 + 50, opacity: 0.8, x: 100)
                                }
                            }
                            Spacer()
                        }.padding()
                    }
                    .frame(height: geometry.size.height + 20)
                    
                    // Bottom Section
                    ZStack {
                        VStack {
                            Spacer().frame(height: 20)
                            Text("Your Photos")
                                .font(.custom("IvyOraDisplay-Regular", size: 48))
                                .foregroundColor(.white)
                            Spacer().frame(height: 20)
                            ScrollView {
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 5) {
                                    ForEach(files, id: \.id) { file in
                                        if let url = URL(string: file.fileURL) {
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .frame(width: geometry.size.width / 2 - 20, height: geometry.size.width / 3 - 20)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: geometry.size.width / 2 - 20, height: geometry.size.width / 3 - 20)
                                                        .clipped()
                                                case .failure:
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: geometry.size.width / 2 - 20, height: geometry.size.width / 3 - 20)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding()
                            }
                            Spacer().frame(height: 20)
                            Button(action: {
                                print("Button tapped")
                            }) {
                                Text("Thank You, Next!")
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: 60)
                                    .background(Color.white)
                                    .cornerRadius(30)
                                    .padding(.horizontal, 30)
                            }
                            .padding(.bottom, 5)
                            Spacer().frame(height: 20)
                        }
                    }
                    .frame(height: geometry.size.height)
                }
                .frame(width: geometry.size.width)
            }
        }
    }
}

#Preview {
    ZStack {
        ColorImageView()
        OpenPhotos()
    }
}
