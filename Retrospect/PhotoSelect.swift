import SwiftUI
import PhotosUI
import Combine

struct PhotoSelect: View {
    @EnvironmentObject var dataStore: capsule
    @State private var showImagePicker = false
    @State private var selectedIndex: Int = 0
    @Binding var state: String

    var body: some View {
        VStack {
            Text(dataStore.images.isEmpty ? "Add Photos" : "These look great!")
                .font(.largeTitle)
                .padding(.top, 100)
                .foregroundColor(.white)
            Spacer()
            
            TabView(selection: $selectedIndex) {
                ForEach(dataStore.images.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack {
                            Image(uiImage: dataStore.images[index])
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
                if dataStore.images.count < 9 {
                    AddImageView(showImagePicker: $showImagePicker, dataStore: dataStore)
                        .tag(dataStore.images.count)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)

            HStack {
                ForEach(0..<dataStore.images.count + (dataStore.images.count < 9 ? 1 : 0), id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.white : Color.white.opacity(0.1))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: selectedIndex)
                }
            }
            .padding(.top, 10)
            Spacer()

            Button(action: {
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
//            .disabled(dataStore.images.isEmpty)
            .padding(.bottom, 100)
        }
    }
}

struct AddImageView: View {
    @Binding var showImagePicker: Bool
    @ObservedObject var dataStore: capsule

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
                ImagePicker(dataStore: dataStore, maxSelection: 9 - dataStore.images.count)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @ObservedObject var dataStore: capsule
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
    ZStack {
        BackgroundImageView()
        PhotoSelect(state: .constant(""))
            .environmentObject(capsule())
    }
}
