import SwiftUI
import PhotosUI

struct PhotoSelect: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var showImagePicker = false
    @Binding var state: String
    
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            if dataStore.images.isEmpty {
                Text("Select up to 9 Photos")
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: 10) {
                        ForEach(dataStore.images, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            
            Button(action: {
                showImagePicker = true
            }) {
                Text("Upload Photos")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(dataStore: self._dataStore, maxSelection: 9)
            }
            Button("Done") {
                state = "SongSelect"
            }
        }
        .padding()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @EnvironmentObject var dataStore: DataStore
    var maxSelection: Int
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dataStore.images.removeAll()
            
            let group = DispatchGroup()
            
            for result in results.prefix(parent.maxSelection) {
                group.enter()
                
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.dataStore.images.append(image)
                            }
                        }
                        group.leave()
                    }
                } else {
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                picker.dismiss(animated: true)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = maxSelection
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}

#Preview {
    PhotoSelect(state: .constant(""))
        .environmentObject(DataStore())
}
