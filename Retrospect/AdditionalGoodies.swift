//
//  AdditionalGoodies.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-02.
//

import SwiftUI
import UniformTypeIdentifiers

struct AdditionalGoodies: View {
    @EnvironmentObject var dataStore: capsule
    @Binding var state: String
    @Binding var AGstate: String
    
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
                            AGstate = "AddText"
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
                            AGstate = "AddAudio"
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
                            AGstate = "AddFile"
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

                        Button(action: {
                            AGstate = "CreateDrawing"
                        }) {
                            VStack {
                                Image(systemName: "pencil.tip")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                Text("Create Drawing")
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
                        state = "SetDate"
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
    AdditionalGoodies(state: .constant(""), AGstate: .constant(""))
        .environmentObject(capsule())
}
