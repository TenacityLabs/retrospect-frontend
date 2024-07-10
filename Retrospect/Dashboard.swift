//
//  Dashboard.swift
//  Retrospect
//
//  Created by John Liu on 2024-06-26.
//

import SwiftUI

struct Dashboard: View {
    @Binding var state: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    Spacer().frame(height: 50)
                    Text("Your Capsules")
                    Spacer().frame(height: 20)
                    Button(action: {
                        state = "IconSelect"
                    }) {
                        Text("Create a new capsule")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }
                    Spacer().frame(height: 20)
                    Text("3/5 capsules in use")
                    Spacer()
                    HStack {
                        Rectangle().frame(width: max(geometry.size.width / 2 - 25, 1), height: 50).background(Color.black)
                        Spacer()
                        Rectangle().frame(width: max(geometry.size.width / 2 - 25, 1), height: 50).background(Color.black)
                    }.padding(.horizontal)
                    HStack {
                        Rectangle().frame(width: max(geometry.size.width / 2 - 25, 1), height: 50).background(Color.black)
                        Spacer()
                        Rectangle().frame(width: max(geometry.size.width / 2 - 25, 1), height: 50).background(Color.black)
                    }.padding(.horizontal)
                    HStack {
                        Rectangle().frame(width: max(geometry.size.width / 2 - 25, 1), height: 50).background(Color.black)
                        Spacer()
                        Rectangle().frame(width: max(geometry.size.width / 2 - 25, 1), height: 50).background(Color.black)
                    }.padding(.horizontal)
                    HStack {
                        Rectangle().frame(width: max(geometry.size.width / 2 - 25, 1), height: 50).background(Color.black)
                        Spacer()
                        Rectangle().frame(width: max(geometry.size.width / 2 - 25, 1), height: 50).background(Color.black)
                    }.padding(.horizontal)
                    HStack {
                        Rectangle().frame(width: max(geometry.size.width / 2 - 25, 1), height: 50).background(Color.black)
                        Spacer()
                        Rectangle().frame(width: max(geometry.size.width / 2 - 25, 1), height: 50).background(Color.black)
                    }.padding(.horizontal)
                    Spacer().frame(height: 50)
                }
                Spacer()
            }
        }

    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard(state: .constant(""))
    }
}

