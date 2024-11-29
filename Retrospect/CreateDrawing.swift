////
////  CreateDrawing.swift
////  Retrospect
////
////  Created by Andrew Durnford on 2024-06-22.
////
//
//import SwiftUI
//import UIKit
//
//struct CreateDrawing: View {
//    @EnvironmentObject var localCapsule: Capsule
//    @State private var selectedIndex: Int = 0
//    @Binding var AGstate: String
//    @Binding var drawIndex: Int
//    
//    @State private var clear = false
//    @State private var color = Color.black
//    @State private var strokeWidth: CGFloat = 2.0
//
//    var body: some View {
//        GeometryReader { geometry in
//            VStack {
//                Text("Drawing Page")
//                    .font(.largeTitle)
//                    .padding()
//
//                    TabView(selection: $selectedIndex) {
//                        ForEach(localCapsule.doodles.indices, id: \.self) { index in
//                            VStack {
//                                DrawingViewRepresentable(clear: $clear, color: $color, strokeWidth: $strokeWidth, paths: $localCapsule.doodles[0], isEditable: false)
//                                    .frame(height: geometry.size.height / 2)
//                                    .border(Color.gray.opacity(0.25), width: 1)
//                            }
//                            .tag(index)
//                        }
//                        if localCapsule.doodles.count < 9 {
//                            Button(action: {
//                                let emptyDrawing = PathWithColor(path: UIBezierPath(), color: .black)
//                                localCapsule.doodles.append([emptyDrawing])
//                            }) {
//                                Image(systemName: "plus")
//                                    .resizable()
//                                    .foregroundColor(.black)
//                                    .frame(width: 30, height: 30)
//                                    .frame(width: 150, height: 150)
//                                    .background(Color.white.opacity(0.2))
//                                    .cornerRadius(15)
//                            }
//                            .tag(localCapsule.doodles.count)
//                        }
//                    }
//                    .tabViewStyle(PageTabViewStyle())
//                
//                
//                HStack {
//                    ForEach(0..<localCapsule.doodles.count + (localCapsule.doodles.count < 9 ? 1 : 0), id: \.self) { index in
//                        Circle()
//                            .fill(index == selectedIndex ? Color.black : Color.gray)
//                            .frame(width: 8, height: 8)
//                            .animation(.easeInOut, value: selectedIndex)
//                    }
//                }
//                .padding(.top, 10)
//                
//                Button(action: {
//                    drawIndex = selectedIndex
//                    AGstate = "EditDrawing"
//                }) {
//                    Text("Edit")
//                        .foregroundColor(Color.black)
//                        .padding()
//                        .frame(width: 300)
//                        .background(Color.white)
//                        .cornerRadius(25)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 25)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                }
//                
//                Button(action: {
//                    AGstate = "AdditionalGoodies"
//                }) {
//                    Text("Done")
//                        .foregroundColor(Color.black)
//                        .padding()
//                        .frame(width: 300)
//                        .background(Color.white)
//                        .cornerRadius(25)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 25)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                }
//
//                Spacer()
//            }
//        }
//        .padding()
//        .onAppear {
//            if localCapsule.doodles.isEmpty || (localCapsule.doodles.count == 1 && localCapsule.doodles[0].isEmpty) {
//                let initialDrawing = PathWithColor(path: UIBezierPath(), color: .black)
//                localCapsule.doodles = [[initialDrawing]]
//            }
//        }
//    }
//}
//
//struct CreateDrawing_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateDrawing(AGstate: .constant(""), drawIndex: .constant(0))
//            .environmentObject(Capsule())
//    }
//}
