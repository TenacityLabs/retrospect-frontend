//
//  AddFile.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-22.
//

import SwiftUI

struct AddFile: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var isDocumentPickerPresented = false
    
    var body: some View {
        VStack {
            Text("Upload File Page")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Button(action: {
                isDocumentPickerPresented.toggle()
            }) {
                Text("Upload File")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .fileImporter(
                isPresented: $isDocumentPickerPresented,
                allowedContentTypes: [.item],
                allowsMultipleSelection: false
            ) { result in
                handleFileSelection(result: result)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func handleFileSelection(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                dataStore.files.append(url)
                print("File selected: \(url)")
            }
        case .failure(let error):
            print("Failed to select file: \(error.localizedDescription)")
        }
    }
}


#Preview {
    AddFile()
        .environmentObject(DataStore())
}
