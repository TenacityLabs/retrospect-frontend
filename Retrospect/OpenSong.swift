//
//  OpenSong.swift
//  Retrospect
//
//  Created by John Liu on 2024-07-15.
//

import Foundation
import SwiftUI

struct OpenSong: View {
    var body: some View {
        GeometryReader {geometry in
            VStack {
                Spacer()
                Text("Throwback Tunes")
                    .font(.custom("IvyOraDisplay-Regular", size: 48))
                    .foregroundColor(.white)
                Spacer()
                if let url = URL(string: "https://slimescholars.com/assets/secrets/angryred.png"),
                                   let imageData = try? Data(contentsOf: url),
                   let uiImage = UIImage(data: imageData) {
                    VStack {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipped()
                        
                        Text("EARFQUAKE")
                            .font(.custom("Syne-Regular", size: 28))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .bold()
                        Text("Tyler, the Creator")
                            .font(.custom("Syne-Regular", size: 20))
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.7))
                    .cornerRadius(15)
                }
                Spacer()
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
                Spacer()
            }
        }
    }
}

#Preview {
    ZStack {
        ColorImageView()
        OpenSong()
    }
}
