//
//  SongSummary.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-11-10.
//

import SwiftUI

struct SongSummary: View {
    let songs: [(title: String, artist: String)] = [
        ("Song Title", "Artist"),
        ("Song Title2", "Artist"),
        ("Song Title3", "Artist"),
        ("Song Title4", "Artist"),
        ("Song Title5", "Artist"),
        ("Song Title6", "Artist"),
        ("Song Title7", "Artist"),
        ("Song Title8", "Artist"),
        ("Song Title9", "Artist"),
        ("Song Title10", "Artist"),
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ZStack {
            BackgroundImageView()
            GeometryReader { geometry in
                VStack {
                    Spacer()
                        .frame(height: 60)
                    
                    Image("box")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Text("Jessica's Box")
                        .foregroundColor(.white)
                        .font(.custom("IvyOraDisplay-RegularItalic", size: 48))
                    
                    Spacer()
                        .frame(height: 40)
                    
                    HStack {
                        Text("Songs you saved")
                            .foregroundColor(.white)
                            .font(.custom("Syne", size: 24))
                        Spacer()
                    }
                    .padding(.leading, 15)
                    
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(songs, id: \.title) { song in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(song.title)
                                        .font(.custom("Public Sans", size: 16))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                
                                HStack {
                                    Text(song.artist)
                                        .font(.custom("Public Sans", size: 16))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.trailing, 40)
                    .padding(.horizontal)
                    
                    Spacer()
                    
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
}

#Preview {
    SongSummary()
}
