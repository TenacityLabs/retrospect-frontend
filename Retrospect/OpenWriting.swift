//
//  OpenWriting.swift
//  Retrospect
//
//  Created by John Liu on 2024-11-09.
//

import SwiftUI


struct OpenWritingData: View {
    @State private var writings: [Writing] = [
        Writing(id: 1, writing: "At dawn, soft whispers rise, and the world reborn is calm with dew on the grass, a fleeting sight, breathing pure and light."),
        Writing(id: 2, writing: "In the sky, soft gleaming stars wink with ancient secrets, unfolding stories in their light."),
        Writing(id: 3, writing: "The rain gently taps on the glass, a quiet dance as moments pass, with each drop singing a sweet, clear melody near."),
        Writing(id: 4, writing: "The breeze whispers through the trees, carrying secrets and bending leaves in a soft, rare caress."),
        Writing(id: 5, writing: "The waves sing on the shore, dancing with tides in a deep lullaby that rocks the sleep forevermore.")
    ]
    
    @State private var selectedWriting: Writing? = nil
    
    func randomPosition(geometry: GeometryProxy) -> CGPoint {
        let width = geometry.size.width
        let height = geometry.size.height
        let x = CGFloat.random(in: 0..<width - 200)
        let y = CGFloat.random(in: 0..<height - 200)
        return CGPoint(x: x + 100, y: y + 100)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(writings, id: \.id) { writing in
                    Rectangle()
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .border(Color.white, width: 2)
                        .frame(width: 200, height: 200)
                        .position(randomPosition(geometry: geometry))
                        .onTapGesture {
                            selectedWriting = writing
                        }
//                        .scaleEffect(selectedWriting?.id == writing.id ? 1.5 : 1)
                        .animation(.easeInOut(duration: 0.3), value: selectedWriting?.id)
                }
                
                VStack {
                    Spacer()
                    Text("Remember \nwhat you \nwrote?")
                        .font(.custom("IvyOraDisplay-Regular", size: 48))
                        .foregroundColor(.white)
                    Spacer()
                }
                
                if let selectedWriting = selectedWriting {
                    VStack {
                        ScrollView {
                            Text(selectedWriting.writing)
                                .font(.custom("Syne-Regular", size: 24))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(10)
                                .frame(width: geometry.size.width - 40, height: geometry.size.height / 2)
                                .overlay(
                                    Button(action: {
                                        self.selectedWriting = nil
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white)
                                            .font(.title)
                                            .padding()
                                            .background(Color.black.opacity(0.9))
                                            .clipShape(Circle())
                                    }
                                    .padding(10)
                                    .opacity(0.4),
                                    alignment: .topTrailing
                                )
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width - 40, height: geometry.size.height / 2)
                    .background(Color.black.opacity(0.95).edgesIgnoringSafeArea(.all))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.yellow.opacity(0.5), lineWidth: 2)
                    )
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ZStack {
        ColorImageView()
        OpenWritingData()
    }
}
