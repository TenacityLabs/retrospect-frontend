//
//  Tutorial.swift
//  Retrospect
//
//  Created by John Liu on 2024-06-23.
//

import SwiftUI

struct Tutorial: View {
    @State private var step = 0
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer().frame(height: 50)
                VStack {
                    HStack(spacing: 5) {
                       ForEach(0..<3) { index in
                           Rectangle()
                               .fill(Color.white)
                               .frame(width: (geometry.size.width - 10) / 3, height: 4)
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
                            Button(action: {
                                globalState.route = "/referrals"
                            }) {
                                Text("Let's go!")
                                    .font(.custom("Syne-Regular", size: 24))
                                    .foregroundColor(Color.black)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 75)
                            .background(Color.white)
                            .cornerRadius(50)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 15)
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
                Spacer().frame(height: 50)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .gesture(
               DragGesture()
                   .onEnded { value in
                       if value.translation.width < -30 {
                           withAnimation {
                               step = min(2, step + 1)
                           }
                       } else if value.translation.width > 30 {
                           withAnimation {
                               step = max(0, step - 1)
                           }
                       }
                   }
            )
        }
    }
}

#Preview {
    ZStack {
        ColorImageView()
        Tutorial()
    }
}
