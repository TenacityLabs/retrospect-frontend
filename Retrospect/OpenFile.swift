//
//  OpenFile.swift
//  Retrospect
//
//  Created by John Liu on 2024-07-15.
//

import SwiftUI
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

struct RoundedTopCorners: Shape {
    var radius: CGFloat = 5
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                    radius: radius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                    radius: radius,
                    startAngle: .degrees(270),
                    endAngle: .degrees(360),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

func getIcon(for file: File) -> UIImage? {
    let url = URL(string: file.fileURL)
    let fileExtension = url?.pathExtension.lowercased() ?? ""
    
    if let type = UTType(filenameExtension: fileExtension) {
        switch type.identifier {
        case UTType.image.identifier:
            if let image = file.photo {
                return image
            } else {
                return UIImage(systemName: "photo.fill")
            }
        case UTType.pdf.identifier:
            return UIImage(systemName: "doc.fill")
        case UTType.text.identifier:
            return UIImage(systemName: "doc.text.fill")
        default:
            return UIImage(systemName: "doc.fill")
        }
    }
    return UIImage(systemName: "doc.fill")
}

let pastelColors: [Color] = [
    Color(red: 0.75, green: 0.60, blue: 0.85), // Pastel Purple
    Color(red: 0.98, green: 0.75, blue: 0.75), // Pastel Red
    Color(red: 0.70, green: 0.85, blue: 0.70), // Pastel Green
    Color(red: 0.67, green: 0.85, blue: 0.90), // Pastel Blue
    Color(red: 1.00, green: 0.80, blue: 0.60),  // Pastel Orange
    Color(red: 0.90, green: 0.90, blue: 0.80)  // Pastel Yellow
]

struct OpenFileData: View {
    let files: [File] = [
        File(id: 1, fileURL: "https://slimescholars.com/assets/audio/tracks/pillar-space.mp3", fileType: "audio/mpeg"),
        File(id: 2, fileURL: "https://slimescholars.com/assets/audio/tracks/pillar-space.mp3", fileType: "audio/mpeg"),
        File(id: 3, fileURL: "https://slimescholars.com/assets/audio/tracks/pillar-space.mp3", fileType: "audio/mpeg"),
        File(id: 4, fileURL: "https://slimescholars.com/assets/audio/tracks/pillar-space.mp3", fileType: "audio/mpeg"),
        File(id: 5, fileURL: "https://slimescholars.com/assets/audio/tracks/pillar-space.mp3", fileType: "audio/mpeg"),
        File(id: 6, fileURL: "https://slimescholars.com/assets/audio/tracks/pillar-space.mp3", fileType: "audio/mpeg"),
    ]
    
    @State private var currentIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Text("Collect \nyour files.")
                    .font(.custom("IvyOraDisplay-Regular", size: 48))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                
                Spacer()
                
                ZStack(alignment: .bottom) {
                    ForEach(0..<files.count, id: \.self) { index in
                        let reversedIndex = files.count - 1 - index
                        let cap: CGFloat = geometry.size.height - CGFloat(185 + (40 * files.count))
                        let height: CGFloat = cap + CGFloat(40 * reversedIndex)
                        let tabWidth: CGFloat = max(1.25 * (geometry.size.width - 24) / CGFloat(files.count), CGFloat(geometry.size.width / 3.5))
                        let tickDistance: CGFloat = CGFloat(geometry.size.width - 24 - tabWidth) / CGFloat(max(files.count - 1, 1))
                        let xOffset: CGFloat =  
                            CGFloat(tabWidth / 2) +
                            CGFloat(reversedIndex) * tickDistance -
                            CGFloat(geometry.size.width / 2 - 12)
                        
                        ZStack(alignment: .top) {
                            FolderView(file: files[reversedIndex],
                                       index: reversedIndex,
                                       currentIndex: $currentIndex)
                                .cornerRadius(12)
                                .frame(width: geometry.size.width, height: height)
                            
                            if files.count > 1 {
                                HStack {
                                    Spacer()
                                    
                                    Button(action: {
                                        currentIndex = index
                                        print(currentIndex)
                                    }) {
                                        Rectangle()
                                            .fill(pastelColors[reversedIndex])
                                            .frame(width: tabWidth, height: 35)
                                            .clipShape(RoundedTopCorners(radius: 2.5))
                                            .overlay(
                                                VStack {
                                                    Color.black.opacity(0.15)
                                                       .frame(height: 3)
                                                        .blur(radius: 2)
                                                        .offset(y: -1.5)
                                                        .clipShape(RoundedTopCorners(radius: 2.5))
                                                    Spacer()
                                                }
                                            )
                                    }
                                    .offset(x: xOffset, y: -30)
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    
                                    Spacer()
                                }
                            }
                        }
                        .frame(width: geometry.size.width, height: height)
                        .alignmentGuide(.bottom) { d in d.height }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct FolderView: View {
    var file: File
    var index: Int
    @Binding var currentIndex: Int
    
    var body: some View {
        VStack {
            Image(uiImage: getIcon(for: file) ?? UIImage(systemName: "doc.fill")!)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
            
            Button(action: {
                if let url = URL(string: file.fileURL) {
                    UIApplication.shared.open(url)
                    print(file.fileURL)
                }
            }) {
                Text("Open \(file.objectName ?? "File")")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding()
                    .shadow(radius: 10)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(pastelColors[index])
        .overlay(
            VStack {
                Color.black.opacity(0.15)
                    .frame(height: 3)
                    .blur(radius: 2)
                    .offset(y: -1.5)
                Spacer()
            }
        )
    }
}


#Preview{
    ZStack {
        ColorImageView()
        OpenFileData()
    }
}

