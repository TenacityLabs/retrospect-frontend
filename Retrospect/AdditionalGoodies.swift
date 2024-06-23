//
//  AdditionalGoodies.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-02.
//

import SwiftUI
import UniformTypeIdentifiers
import PencilKit
import UIKit

struct AdditionalGoodies: View {
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Additional Goodies:")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                HStack {
                    NavigationLink(destination: {
                        AddText()
                            .environmentObject(dataStore)
                    }) {
                        Text("add text")
                            .frame(width: 100, height: 100)
                            .background(Color.gray)
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                    NavigationLink(destination: {
                        AddAudio()
                            .environmentObject(dataStore)
                    }) {
                        Text("add audio")
                            .frame(width: 100, height: 100)
                            .background(Color.gray)
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                }
                HStack {
                    NavigationLink(destination: {
                        AddFile()
                            .environmentObject(dataStore)
                    }) {
                        Text("upload file")
                            .frame(width: 100, height: 100)
                            .background(Color.gray)
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                    NavigationLink(destination: {
                        CreateDrawing()
                            .environmentObject(dataStore)
                    }) {
                        Text("create drawing")
                            .frame(width: 100, height: 100)
                            .background(Color.gray)
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text("check mark")
                        .frame(width: 100, height: 100)
                        .background(Color.gray)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    AdditionalGoodies()
        .environmentObject(DataStore())
}
