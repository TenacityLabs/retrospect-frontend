//
//  Tutorial.swift
//  Retrospect
//
//  Created by John Liu on 2024-06-23.
//

import SwiftUI

struct Tutorial: View {
    @State private var step = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    HStack(spacing: 5) {
                       ForEach(0..<3) {
                           index in
                           Rectangle()
                               .fill(Color.white)
                               .frame(width: geometry.size.width / 3 - 5, height: 4)
                               .opacity(step == index ? 0.8 : 0.2)
                               .animation(.easeInOut, value: step)
                               .cornerRadius(.infinity)
                       }
                   }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    Text("How it Works")
                        .foregroundColor(.white)
                }
                Spacer()
                ZStack {
                    if step == 0 {
                        VStack {
                            Text("Save your memories in a digital Capsule")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            Spacer().frame(height: 20)
                            Text("Add photos, songs, text and more - all native in-app.")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 30)
                    }
                    else if step == 1 {
                        VStack {
                            Text("Memories that last Forever")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            Spacer().frame(height: 20)
                            Text("Choose a date and lock your time capsule.")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            Spacer().frame(height: 20)
                            Text("You will be notified when your capsule is ready to be viewed.")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 30)
                        
                    } else {
                        VStack {
                            Text("Share and Collaborate")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            Spacer().frame(height: 20)
                            Text("Own up to 5 capsules.")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            Spacer().frame(height: 20)
                            Text("Join infinite capsules.")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            Spacer().frame(height: 20)
                            Text("Share a link to collaborate with your friends.")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 30)
                    }
                }
                Spacer()
                VStack {
                    HStack {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray).opacity(0.75)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray).opacity(0.75)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray).opacity(0.75)
                    }
                    Spacer().frame(height: 10)
                    Text("Swipe to Continue")
                        .foregroundColor(.gray)
                }
            }
        }
        .gesture(
           DragGesture()
               .onEnded { value in
                   if value.translation.width < -50 {
                       withAnimation {
                           step = min(2, step + 1)
                       }
                   } else if value.translation.width > 50 {
                       withAnimation {
                           step = max(0, step - 1)
                    }
                }
            }
        )
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        Tutorial()
    }
}
