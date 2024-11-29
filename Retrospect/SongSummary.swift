import SwiftUI

struct SongSummary: View {
    // Array of Song objects
    let songs: [Song] = [
        Song(id: 1, spotifyId: "72gv4zhNvRVdQA0eOenCal?si=96e5072fefbc4443", name: "Symphony (feat. Zara Larsson)", artistName: "Clean Bandit, Zara Larsson", albumArtURL: ""),
        Song(id: 2, spotifyId: "28qA8y1sz0FTuSapsCxNOG?si=234bd9571cef4461", name: "Father Time", artistName: "Kendrick Lamar, Sampha", albumArtURL: ""),
        Song(id: 3, spotifyId: "124NFj84ppZ5pAxTuVQYCQ?si=714d11c4f14946f6", name: "Take Care", artistName: "Drake, Rihanna", albumArtURL: ""),
        Song(id: 4, spotifyId: "5vNRhkKd0yEAg8suGBpjeY?si=369bc044c6a74f2a", name: "APT.", artistName: "ROSÉ, Bruno Mars", albumArtURL: ""),
        Song(id: 5, spotifyId: "754hhnczVNu3ibRaoAcujX?si=80e95c08bb7b4fc1", name: "killstreaks (with Don Toliver & PinkPantheress) also a long title test", artistName: "Baby Keem", albumArtURL: "")
    ]
    
    // Grid configuration
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
                        ForEach(songs, id: \.id) { song in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(song.name)
                                        .font(.custom("Public Sans", size: 16))
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                    Spacer()
                                }
                                
                                HStack {
                                    Text(song.artistName)
                                        .font(.custom("Public Sans", size: 16))
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
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
