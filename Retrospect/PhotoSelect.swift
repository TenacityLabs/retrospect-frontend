import SwiftUI
import PhotosUI
import Combine

//FIXME: need to implement remove image button, logic for deleting images in backend vs frontend
//FIXME: duplicate checking is broken

struct PhotoSelect: View {
    @EnvironmentObject var globalState: GlobalState
    @State private var showImagePicker = false
    @State private var selectedIndex: Int = 0
    @State private var photos: [APIPhoto] = []

    var body: some View {
        VStack {
            Text(photos.isEmpty ? "Add Photos" : "These look great!")
                .font(.largeTitle)
                .padding(.top, 100)
                .foregroundColor(.white)
            Spacer()
            
            TabView(selection: $selectedIndex) {
                ForEach(photos.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack {
                            if (photos[index] != nil) {
                                if let url = URL(string: photos[index].fileURL),
                                   let imageData = try? Data(contentsOf: url),
                                   let uiImage = UIImage(data: imageData){
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(15)
                                        .padding(20)
                                        .frame(maxHeight: 300)
                                }
                            } else {
                                AsyncImage(url: URL(string: photos[index].fileURL)) {
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
                        }
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }
                    .padding(.horizontal, 20)
                    .tag(index)
                }
                
                if photos.count < 9 {
                    AddImageView(showImagePicker: $showImagePicker, photos: $photos)
                        .tag(photos.count)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)
            
            HStack {
                ForEach(0..<photos.count + (photos.count < 9 ? 1 : 0), id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.white : Color.white.opacity(0.1))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: selectedIndex)
                }
            }
            .onChange(of: photos) {
                photos = Array(Set(photos))
            }
            .padding(.top, 10)
            Spacer()
            
            Button(action: {
                if photos[selectedIndex].uploaded {
                    let body: [String: Any] = ["capsuleId": globalState.focusCapsule?.capsule.id, "PhotoId": photos[selectedIndex].id]
                    CapsuleAPIClient.shared.delete(authorization: globalState.jwt, mediaType: .photo, body: body)
                    {_ in}
                }
                
                photos.remove(at: selectedIndex)
                if selectedIndex != 0 {
                    selectedIndex -= 1
                }
                
            }) {
                Text("Delete Photo")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .opacity(photos.count < 1 || selectedIndex == photos.count ? 0.5 : 1.0)
            .disabled(photos.count < 1 || selectedIndex == photos.count)
            
            Button(action: {
                globalState.focusCapsule?.photos = photos
                uploadPhotos(globalState: globalState, photoArray: photos, completing: { arr, ind, newId in
                    photos[ind].id = newId
                    photos[ind].uploaded = true
                })
                globalState.route = "/capsule/song-select"
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
            .padding(.bottom, 100)
        }
        .onAppear(perform: {
            photos = globalState.focusCapsule?.photos ?? []
        })
    }
}

struct AddImageView: View {
    @Binding var showImagePicker: Bool
    @Binding var photos: [APIPhoto]

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
                ImagePicker(maxSelection: 9 - photos.count, photos: $photos)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    var maxSelection: Int
    @Binding var photos: [APIPhoto]

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
                                    let newImage = APIPhoto(fileURL: fileURL.absoluteString, uploaded: false, fileType: fileType)
                                    self.parent.photos.append(newImage)
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

@MainActor func uploadPhotos(globalState: GlobalState, photoArray: [APIPhoto], completing: @escaping([APIPhoto], Int, UInt) -> Void) {
    for (index, photo) in photoArray.enumerated() {
        CapsuleAPIClient.shared.upload(
            authorization: globalState.jwt,
            fileURL: URL(string: photo.fileURL)!,
            fileType: photo.fileType)
        { result in
            switch result {
                case .success(let result):
                    let body: [String: Any] = [
                        "authorization": globalState.jwt,
                        "capsuleID": globalState.focusCapsule?.capsule.id,
                        "objectName": result.objectName,
                        "fileURL": result.fileURL
                    ]
                    
                    CapsuleAPIClient.shared.create(
                        authorization: globalState.jwt,
                        mediaType: .photo,
                        body: body)
                    { createResult in
                        switch createResult {
                        case .success(let createResult):
                            completing(photoArray, index, createResult.id)
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

#Preview {
    ZStack {
        BackgroundImageView()
        PhotoSelect().environmentObject(GlobalState())
    }
}
