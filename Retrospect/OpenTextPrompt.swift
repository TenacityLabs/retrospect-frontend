//
//  OpenTextPrompt.swift
//  Retrospect
//
//  Created by John Liu on 2024-07-15.
//

import Foundation
import SwiftUI

struct OpenTextData: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("wtf u say")
                    .font(.custom("IvyOraDisplay-Regular", size: 48))
                    .foregroundColor(.white)
                Spacer()
                FlipCardView()
                Spacer()
                Button(action: {
                }) {
                    Text("Thank You, Next!")
                        .foregroundColor(.black)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(Color.white)
                .cornerRadius(30)
                .padding(.horizontal, 30)
                .padding(.bottom, 5)
                Spacer()
            }
        }
    }
}

struct FlipCardView: View {
    @State private var flipped = false
    @State private var angle = 0.0

    var body: some View {
        ZStack {
            FrontView(flipped: $flipped, flipAction: flipCard)
                .opacity(flipped ? 0 : 1)
                .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0))
            BackView(flipped: $flipped, flipAction: flipCard)
                .opacity(flipped ? 1 : 0)
                .rotation3DEffect(.degrees(angle + 180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: 300, height: 200) // Adjust the size as needed
        .background(Color.clear)
        .cornerRadius(15)
        .shadow(radius: 5)
    }

    private func flipCard() {
        withAnimation(.easeInOut(duration: 0.8)) {
            angle += 180
            flipped.toggle()
        }
    }
}

struct FrontView: View {
    @Binding var flipped: Bool
    var flipAction: () -> Void

    var body: some View {
        VStack {
            HStack {
                Text("We asked you")
                    .font(.custom("Syne-Regular", size: 15))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .bold()
                Spacer()
                Button(action: {
                    flipAction()
                }) {
                    Image(systemName: "arrow.2.circlepath")
                        .font(.custom("Syne-Regular", size: 20))
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .padding()
            Spacer()
            VStack {
                Text("What's one item you'd bring to a deserted island?")
                    .font(.custom("Syne-Regular", size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding()
            Spacer()
        }
        .frame(width: 300, height: 200) // Adjust the size as needed
        .background(Color.black)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct BackView: View {
    @Binding var flipped: Bool
    var flipAction: () -> Void

    var body: some View {
        VStack {
            HStack {
                Text("Your response")
                    .font(.custom("Syne-Regular", size: 15))
                    .foregroundColor(.black)
                    .padding(.top, 10)
                    .bold()
                Spacer()
                Button(action: {
                    flipAction()
                }) {
                    Image(systemName: "arrow.2.circlepath")
                        .font(.custom("Syne-Regular", size: 20))
                        .foregroundColor(.black)
                        .padding()
                }
            }
            .padding()
            Spacer()
            VStack {
                Text("Idfk bruh i’m very confused")
                    .font(.custom("Syne-Regular", size: 20))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
            .padding()
            Spacer()
        }
        .frame(width: 300, height: 200) // Adjust the size as needed
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    ZStack {
        ColorImageView()
        OpenTextData()
    }
}
