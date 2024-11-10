//
//  PhotoSummary.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-11-10.
//

import SwiftUI

struct PhotoSummary: View {
    var body: some View {
        ZStack {
            BackgroundImageView()
            GeometryReader { geometry in
                VStack {
                    Spacer()
                        .frame(height: 40)

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
                    
                    if let url = URL(string: "https://aboffs.com/cdn/shop/products/2066-60-honolulublue_37713baa-8046-469c-bff5-f36653a376cb_1600x.png?v=1587091011"),
                       let imageData = try? Data(contentsOf: url),
                       let uiImage = UIImage(data: imageData) {
                        Group {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .rotationEffect(.degrees(-15))
                                .position(x: geometry.size.width / 4, y: geometry.size.height / 8 - 25)
                            
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 125, height: 125)
                                .rotationEffect(.degrees(5))
                                .position(x: geometry.size.width * 2.9 / 4, y: 0)
                            
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 115, height: 115)
                                .rotationEffect(.degrees(-5))
                                .position(x: geometry.size.width * 0.25, y: 50)
                            
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(10))
                                .position(x: geometry.size.width * 0.7, y: -50)
                            
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(10))
                                .position(x: geometry.size.width * 0.2, y: 0)
                            
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .rotationEffect(.degrees(-5))
                                .position(x: geometry.size.width * 0.65, y: -75)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .lastTextBaseline) {
                        // Logo Image
                        Image("Logo White")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 10)
                        
                        // "Retrospect" Title Text
                        Text("Retrospect")
                            .foregroundColor(.white)
                            .font(.custom("IvyOra Display", size: 24))
                        
                        Spacer()
                        
                        // Website Text
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
}

#Preview {
    PhotoSummary()
}
