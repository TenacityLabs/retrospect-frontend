//
//  AdditionalGoodies.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-02.
//

import SwiftUI
import UniformTypeIdentifiers

struct AdditionalGoodies: View {
    @EnvironmentObject var globalState: GlobalState
    
    let buttonWidth: CGFloat = 100
    let buttonHeight: CGFloat = 100
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Additional Goodies:")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()

                // Grid layout for buttons
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        Button(action: {
                            globalState.route = "/ag/add-text"
                        }) {
                            VStack {
                                Image(systemName: "text.bubble")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                Text("Add Text")
                            }
                            .frame(width: buttonWidth, height: buttonHeight)
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(15)
                        }

                        Button(action: {
                            globalState.route = "/ag/add-audio"
                        }) {
                            VStack {
                                Image(systemName: "waveform")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                Text("Add Audio")
                            }
                            .frame(width: buttonWidth, height: buttonHeight)
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(15)
                        }
                    }

                    HStack(spacing: 20) {
                        Button(action: {
                            globalState.route = "/ag/add-file"
                        }) {
                            VStack {
                                Image(systemName: "doc")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                Text("Add File")
                            }
                            .frame(width: buttonWidth, height: buttonHeight)
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(15)
                        }
                    }
                }
                .padding()

                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        globalState.route = "/capsule/set-date"
                    }) {
                        Text("Done")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                    Spacer()
                }
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    AdditionalGoodies()
}
