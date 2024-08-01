////
////  AdditionalGoodies.swift
////  Retrospect
////
////  Created by Andrew Durnford on 2024-06-02.
////
//
//import SwiftUI
//import UniformTypeIdentifiers
//
//struct AdditionalGoodies: View {
//    @EnvironmentObject var localCapsule: Capsule
//    @Binding var state: String
//    @Binding var AGstate: String
//    
//    let buttonWidth: CGFloat = 100
//    let buttonHeight: CGFloat = 100
//    
//    init(state: Binding<String>, AGstate: Binding<String>) {
//        self._state = state
//        self._AGstate = AGstate
//        
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground()
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
//    }
//    
//    var body: some View {
//        VStack {
//            VStack {
//                Text("Additional Goodies:")
//                    .font(.largeTitle)
//                    .padding()
//                
//                Spacer()
//
//                // Grid layout for buttons
//                VStack(spacing: 20) {
//                    HStack(spacing: 20) {
//                        Button(action: {
//                            AGstate = "AddText"
//                        }) {
//                            VStack {
//                                Image(systemName: "text.bubble")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 50, height: 50)
//                                Text("Add Text")
//                            }
//                            .frame(width: buttonWidth, height: buttonHeight)
//                            .padding()
//                            .background(Color.clear)
//                            .cornerRadius(15)
//                        }
//
//                        Button(action: {
//                            AGstate = "AddAudio"
//                        }) {
//                            VStack {
//                                Image(systemName: "waveform")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 50, height: 50)
//                                Text("Add Audio")
//                            }
//                            .frame(width: buttonWidth, height: buttonHeight)
//                            .padding()
//                            .background(Color.clear)
//                            .cornerRadius(15)
//                        }
//                    }
//
//                    HStack(spacing: 20) {
//                        Button(action: {
//                            AGstate = "AddFile"
//                        }) {
//                            VStack {
//                                Image(systemName: "doc")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 50, height: 50)
//                                Text("Add File")
//                            }
//                            .frame(width: buttonWidth, height: buttonHeight)
//                            .padding()
//                            .background(Color.clear)
//                            .cornerRadius(15)
//                        }
//
//                        Button(action: {
//                            AGstate = "CreateDrawing"
//                        }) { 
//                            VStack {
//                                Image(systemName: "pencil.tip") 
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 50, height: 50)
//                                Text("Create Drawing")
//                            }
//                            .frame(width: buttonWidth, height: buttonHeight)
//                            .padding()
//                            .background(Color.clear)
//                            .cornerRadius(15)
//                        }
//                    }
//                    HStack(spacing: 20) {
//                        Button(action: {
//                            AGstate = "AddFile"
//                        }) {
//                            VStack {
//                                Image(systemName: "doc")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 50, height: 50)
//                                Text("Add File")
//                            }
//                            .frame(width: buttonWidth, height: buttonHeight)
//                            .padding()
//                            .background(Color.clear)
//                            .cornerRadius(15)
//                        }
//
//                        Button(action: {
//                            AGstate = "CreateDrawing"
//                        }) {
//                            VStack {
//                                Image(systemName: "pencil.tip")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 50, height: 50)
//                                Text("Create Drawing")
//                            }
//                            .frame(width: buttonWidth, height: buttonHeight)
//                            .padding()
//                            .background(Color.clear)
//                            .cornerRadius(15)
//                        }
//                    }
//                    HStack(spacing: 20) {
//                        Button(action: {
//                            AGstate = "AddFile"
//                        }) {
//                            VStack {
//                                Image(systemName: "doc")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 50, height: 50)
//                                Text("Add File")
//                            }
//                            .frame(width: buttonWidth, height: buttonHeight)
//                            .padding()
//                            .background(Color.clear)
//                            .cornerRadius(15)
//                        }
//                        Spacer().frame(width: buttonWidth, height: buttonHeight)
//                            .padding()
//                    }
//                }
//                .padding()
//
//                Spacer()
//                
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        state = "SetDate"
//                    }) {
//                        Text("Done")
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(width: 100)
//                            .background(Color.blue)
//                            .cornerRadius(25)
//                    }
//                    Spacer()
//                }
//                .padding(.bottom, 20)
//            }
//            .background(Color.clear)
//            .navigationBarHidden(true)
//        }
//        .background(Color.clear)
//    }
//}
//
//#Preview {
//    ZStack {
//        ColorImageView()
//        AdditionalGoodies(state: .constant(""), AGstate: .constant(""))
//            .environmentObject(Capsule())
//    }
//}
