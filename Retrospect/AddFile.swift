import SwiftUI
import UniformTypeIdentifiers

struct AddFile: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var isDocumentPickerPresented = false
    @Binding var AGstate: String
    
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
                allowedContentTypes: [.pdf],
                allowsMultipleSelection: false
            ) { result in
                handleFileSelection(result: result)
            }
            
            Spacer()
        Button(action: {
            AGstate = "AdditionalGoodies"
        }) {
            Text("I'm Done!")
                .foregroundColor(.white)
                .padding()
                .frame(width: 300)
                .background(Color.gray)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.black, lineWidth: 1)
                )
        }
        .padding(.horizontal, 20)
        }
        .padding()
    }
    
    private func handleFileSelection(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                do {
                    let fileSize = try url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
                    let fileSizeInMB = Double(fileSize) / (1024 * 1024)
                    if fileSizeInMB <= 5 {
                        dataStore.files.append(url)
                        print("File selected: \(url)")
                    } else {
                        print("File size exceeds 5MB limit")
                        // Show an alert or user message about the file size limit
                    }
                } catch {
                    print("Failed to retrieve file size: \(error.localizedDescription)")
                    // Show an alert or user message about the error
                }
            }
        case .failure(let error):
            print("Failed to select file: \(error.localizedDescription)")
            // Show an alert or user message about the failure
        }
    }
}

#Preview {
    AddFile(AGstate: .constant(""))
        .environmentObject(DataStore())
}
