import SwiftUI
import PhotosUI
import Combine

//FIXME: need to display images that are in backend & not display uploaded images
//FIXME: need to implement remove image button, logic for deleting images in backend vs frontend

struct PhotoSelect: View {
    @EnvironmentObject var localCapsule: Capsule
    @State private var showImagePicker = false
    @State private var selectedIndex: Int = 0
    @Binding var state: String

    var body: some View {
        VStack {
            Text(localCapsule.images.isEmpty ? "Add Photos" : "These look great!")
                .font(.largeTitle)
                .padding(.top, 100)
                .foregroundColor(.white)
            Spacer()
            
            TabView(selection: $selectedIndex) {
                ForEach(localCapsule.images.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack {
                            Image(uiImage: localCapsule.images[index].image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                                .padding(20)
                                .frame(maxHeight: 300)
                        }
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }
                    .padding(.horizontal, 20)
                    .tag(index)
                }
                if localCapsule.images.count < 9 {
                    AddImageView(showImagePicker: $showImagePicker, localCapsule: localCapsule)
                        .tag(localCapsule.images.count)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)

            HStack {
                ForEach(0..<localCapsule.images.count + (localCapsule.images.count < 9 ? 1 : 0), id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.white : Color.white.opacity(0.1))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: selectedIndex)
                }
            }
            .padding(.top, 10)
            Spacer()

            Button(action: {
                uploadFiles(capsule: localCapsule, type: .photo)
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
//            .disabled(localCapsule.images.isEmpty)
            .padding(.bottom, 100)
        }
    }
}

struct AddImageView: View {
    @Binding var showImagePicker: Bool
    @ObservedObject var localCapsule: Capsule

    var body: some View {
        VStack {
            Button(action: {
                showImagePicker = true
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .frame(width: 150, height: 150)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(localCapsule: localCapsule, maxSelection: 9 - localCapsule.images.count)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @ObservedObject var localCapsule: Capsule
    var maxSelection: Int

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            let group = DispatchGroup()

            for result in results.prefix(parent.maxSelection) {
                group.enter()

                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            let fileType = result.itemProvider.registeredTypeIdentifiers.first ?? "unknown"
                            let fileURL = self.saveImageAndGetURL(image: image, fileType: fileType)

                            DispatchQueue.main.async {
                                if let fileURL = fileURL {
                                    let newImage = Images(image: image, fileURL: fileURL, fileType: fileType)
                                    self.parent.localCapsule.images.append(newImage)
                                }
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

        private func saveImageAndGetURL(image: UIImage, fileType: String) -> URL? {
            let imageData: Data?
            let fileExtension: String
            
            switch fileType.lowercased() {
            case "public.png":
                imageData = image.pngData()
                fileExtension = "png"
            case "public.jpeg":
                imageData = image.jpegData(compressionQuality: 1.0)
                fileExtension = "jpg"
            default:
                return nil
            }
            
            guard let data = imageData else {
                return nil
            }
            
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileName = UUID().uuidString + "." + fileExtension
            let fileURL = tempDirectory.appendingPathComponent(fileName)
            
            do {
                try data.write(to: fileURL)
                return fileURL
            } catch {
                print("Error saving image: \(error)")
                return nil
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

@MainActor func uploadFiles(capsule: Capsule, type: MediaType) {
    for index in capsule.images.indices {
        if !(capsule.images[index].uploaded) {
            CapsuleAPIClient.shared.uploadFile(
                authorization: jwt,
                fileURL: capsule.images[index].fileURL,
                fileType: capsule.images[index].fileType)
            { result in
                switch result {
                case .success(let result):
                    
                    CapsuleAPIClient.shared.createMedia(
                        authorization: jwt,
                        mediaType: type,
                        capsuleId: (backendCapsule?.capsule.id)!,
                        objectName: result.objectName,
                        fileURL: result.fileURL
                        )
                    { result in
                        switch result {
                        case .success(let result):
                            print("Uploaded")
                            capsule.images[index].id = result.id
                            capsule.images[index].uploaded = true
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        PhotoSelect(state: .constant(""))
            .environmentObject(Capsule())
    }
}
