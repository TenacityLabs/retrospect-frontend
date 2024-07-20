//
//  PhotoTest.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-07-19.
//

import SwiftUI
import PhotosUI
import Combine

struct PhotoTest: View {
    @State private var selectedIndex: Int = 0
    @State private var currentCapsule: APICapsule = APICapsule()
    @Binding var state: String

    var body: some View {
        VStack {

            TabView(selection: $selectedIndex) {
                ForEach(currentCapsule.photos.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack {
                            AsyncImage(url: URL(string: currentCapsule.photos[index].fileURL)) {
                                phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .cornerRadius(15)
                                            .padding(20)
                                            .frame(maxHeight: 300)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(15)
                                            .padding(20)
                                            .frame(maxHeight: 300)
                                    case .failure:
                                        ProgressView()
                                            .cornerRadius(15)
                                            .padding(20)
                                            .frame(maxHeight: 300)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                        }
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }
                    .padding(.horizontal, 20)
                    .tag(index)
                }
            }
            .onAppear() {
                CapsuleAPIClient.shared.getCapsuleById(
                    authorization: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcmVkQXQiOjE3MjIwMTY2NjYsInVzZXJJRCI6IjMifQ.-RjqW323obq1D4tVzOK5liaPh3H3AqARyn3dSwR2mBY",
                    id: 45)
                { result in
                    switch result {
                    case .success(let capsule):
                        currentCapsule = capsule
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)

            HStack {
                ForEach(0..<currentCapsule.photos.count + (currentCapsule.photos.count < 9 ? 1 : 0), id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.white : Color.white.opacity(0.1))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: selectedIndex)
                }
            }
            .padding(.top, 10)
            Spacer()

            Button(action: {
                uploadFiles(type: .photo)
                state = "SongSelect"
            }) {
                Text("bogos binted")
                    .foregroundColor(Color.black)
                    .padding()
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
//            .disabled(currentCapsule.images.isEmpty)
            .padding(.bottom, 100)
        }
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        PhotoTest(state: .constant(""))
            .environmentObject(Capsule())
    }
}
