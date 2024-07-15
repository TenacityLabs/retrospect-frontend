//
//  OpenPhotos.swift
//  Retrospect
//
//  Created by John Liu on 2024-07-15.
//

import Foundation
import SwiftUI

struct OpenPhotos: View {
    let imageURLs: [String] = [
        "https://slimescholars.com/assets/secrets/el fizzo.png",
        "https://slimescholars.com/assets/secrets/el fizzo.png",
        "https://slimescholars.com/assets/secrets/el fizzo.png",
        "https://slimescholars.com/assets/secrets/el fizzo.png",
        "https://slimescholars.com/assets/secrets/el fizzo.png",
        "https://slimescholars.com/assets/secrets/el fizzo.png",
        "https://slimescholars.com/assets/secrets/el fizzo.png",
        "https://slimescholars.com/assets/secrets/el fizzo.png",
        "https://slimescholars.com/assets/secrets/el fizzo.png",
        "https://slimescholars.com/assets/secrets/el fizzo.png",
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        Text("✨").font(.custom("Syne-Regular", size: 56))
                            .position(x: geometry.size.width - 100, y: 80)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("10").font(.custom("Syne-Regular", size: 56))
                                .foregroundColor(.white)
                            Text("botos").font(.custom("IvyOraDisplay-Regular", size: 48))
                                .foregroundColor(.white)
                            Text("binted").font(.custom("IvyOraDisplay-Regular", size: 48))
                                .foregroundColor(.white)
                        }
                        .position(x: 100, y: 350)
                        
                        Image(systemName: "arrow.down")
                            .font(.system(size: 56))
                            .foregroundColor(.white)
                            .position(x: geometry.size.width - 75, y: 500)
                        
                        if let url = URL(string: "https://slimescholars.com/assets/secrets/haha.jpeg"),
                           let imageData = try? Data(contentsOf: url),
                           let uiImage = UIImage(data: imageData) {
                            Group {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .padding(10)
                                    .background(Color.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .rotationEffect(.degrees(15))
                                    .position(x: 75, y: 100)
                                    .opacity(0.5)
                                
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .padding(10)
                                    .background(Color.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .rotationEffect(.degrees(-10))
                                    .position(x: geometry.size.width - 75, y: 300)
                                    .opacity(0.5)
                                
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .padding(10)
                                    .background(Color.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .rotationEffect(.degrees(-10))
                                    .position(x: geometry.size.width - 50, y: geometry.size.height - 100)
                                    .opacity(0.35)
                                
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 300, height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .padding(10)
                                    .background(Color.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .rotationEffect(.degrees(15))
                                    .position(x: 75, y: 675)
                            }
                        }
                    }
                    .frame(height: geometry.size.height)
                    
                    Spacer()
                        .frame(height: geometry.size.height / 2)
                    
                    // Second page content
                    ZStack {
                        VStack {
                            Text("Your Photos")
                                .font(.custom("IvyOraDisplay-Regular", size: 48))
                                .foregroundColor(.white)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 5) {
                                ForEach(imageURLs.indices, id: \.self) { index in
                                    if let url = URL(string: imageURLs[index]),
                                       let imageData = try? Data(contentsOf: url),
                                       let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width / 2 - 20, height: geometry.size.width / 3 - 20)
                                            .clipped()
                                          .clipShape(RoundedRectangle(cornerRadius: 10))
                                          .background(Color.gray.opacity(0.3))
                                          .cornerRadius(10)
                                    }
                                }
                                .padding()
                            }
                            Button(action: {
                            }) {
                                Text("Thank You, Next!")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .background(Color.white )
                            .cornerRadius(30)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 5)
                            Spacer().frame(height: geometry.size.height/3)
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
