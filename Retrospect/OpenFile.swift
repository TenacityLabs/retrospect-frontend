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
    Color(red: 1.00, green: 0.80, blue: 0.60)  // Pastel Orange
]

struct OpenFileData: View {
    let files: [File] = [
        File(id: 1, fileURL: "https://slimescholars.com/assets/audio/tracks/pillar-space.mp3", fileType: "audio/mpeg"),
        File(id: 2, fileURL: "https://musopen.org/media/works/2/2/2222/2222.pdf", fileType: "application/pdf"),
        File(id: 3, fileURL: "https://musopen.org/media/works/3/3/3333/3333.jpg", fileType: "image/jpeg"),
        File(id: 4, fileURL: "https://musopen.org/media/works/4/4/4444/4444.txt", fileType: "text/plain"),
        File(id: 5, fileURL: "https://musopen.org/media/works/5/5/5555/5555.zip", fileType: "application/zip")
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
                        let cap: CGFloat = geometry.size.height - CGFloat(225 + (40 * files.count))
                        let height: CGFloat = cap + CGFloat(40 * reversedIndex)
                        let tabWidth: CGFloat = (geometry.size.width - 24) / CGFloat(files.count)
                        let xOffset: CGFloat = CGFloat(index + 1) * tabWidth - CGFloat(geometry.size.width / 2 - 12) - CGFloat(tabWidth / 2)
                        
                        VStack (spacing: 0) {
                            HStack {
                                Spacer()
                                Rectangle()
                                    .fill(pastelColors[reversedIndex])
                                    .frame(width: tabWidth, height: 35)
                                    .cornerRadius(2.5)
                                    .offset(x: xOffset)
                                Spacer()
                            }
                            FolderView(file: files[reversedIndex],
                                       index: reversedIndex,
                                       currentIndex: $currentIndex)
                            .cornerRadius(12)
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
    }
}


#Preview{
    ZStack {
        ColorImageView()
        OpenFileData()
    }
}

