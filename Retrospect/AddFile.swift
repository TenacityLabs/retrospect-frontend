//import SwiftUI
//import UniformTypeIdentifiers
//import PDFKit
//
//struct AddFile: View {
//    @State private var isDocumentPickerPresented = false
//    @Binding var AGstate: String
//    @State private var selectedIndex: Int = 0
//    @State private var files: [File] = backendCapsule.miscFiles
//    
//    var body: some View {
//        VStack {
//            Text(files.isEmpty ? "Add Files" : "These look great!")
//                .font(.largeTitle)
//                .padding(.top, 100)
//                .foregroundColor(.white)
//            Spacer()
//            
//            TabView(selection: $selectedIndex) {
//                ForEach(files.indices, id: \.self) { index in
//                    GeometryReader { geometry in
//                        VStack {
//                            PDFPreviewView(url: URL(string: files[index].fileURL)!)
//                                .frame(maxHeight: 320)
//                                .cornerRadius(15)
//                                .shadow(radius: 5)
//                                .padding(.vertical, 5)
//                            Text(URL(string: files[index].fileURL)!.lastPathComponent)
//                                .foregroundColor(.white)
//                                .padding(.vertical, 5)
//                        }
//                        .padding(20)
//                        .background(Color.white.opacity(0.2))
//                        .cornerRadius(15)
//                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
//                    }
//                    .padding(.horizontal, 20)
//                    .tag(index)
//                }
//                if files.count < 9 {
//                    Button(action: {
//                        isDocumentPickerPresented = true
//                    }) {
//                        Image(systemName: "plus")
//                            .resizable()
//                            .foregroundColor(.white)
//                            .frame(width: 30, height: 30)
//                            .frame(width: 150, height: 150)
//                            .background(Color.white.opacity(0.2))
//                            .cornerRadius(15)
//                    }
//                    .tag(files.count)
//                    .fileImporter(
//                        isPresented: $isDocumentPickerPresented,
//                        allowedContentTypes: [.pdf],
//                        allowsMultipleSelection: true // Allow multiple selection
//                    ) { result in
//                        isDocumentPickerPresented = false
//                        handleFileSelection(result: result)
//                    }
//                }
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            .frame(height: 400)
//
//            HStack {
//                ForEach(0..<files.count + (files.count < 9 ? 1 : 0), id: \.self) { index in
//                    Circle()
//                        .fill(index == selectedIndex ? Color.white : Color.white.opacity(0.1))
//                        .frame(width: 8, height: 8)
//                        .animation(.easeInOut, value: selectedIndex)
//                }
//            }
//            .padding(.top, 10)
//            Spacer()
//            
//            Button(action: {
//                if files[selectedIndex].uploaded {
//                    let body: [String: Any] = ["capsuleId": backendCapsule.capsule.id, "miscFileId": files[selectedIndex].id!]
//                    CapsuleAPIClient.shared.delete(authorization: jwt, mediaType: .miscFile, body: body)
//                    {_ in}
//                }
//                
//                files.remove(at: selectedIndex)
//                if selectedIndex != 0 {
//                    selectedIndex -= 1
//                }
//                
//            }) {
//                Text("Delete File")
//                    .foregroundColor(.black)
//                    .padding()
//                    .frame(width: 300)
//                    .background(Color.white)
//                    .cornerRadius(25)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 25)
//                            .stroke(Color.black, lineWidth: 1)
//                    )
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 10)
//            .opacity(files.count < 1 || selectedIndex == files.count ? 0.5 : 1.0)
//            .disabled(files.count < 1 || selectedIndex == files.count)
//
//            Button(action: {
//                backendCapsule.miscFiles = files
//                uploadFiles()
//                AGstate = "AdditionalGoodies"
//            }) {
//                Text("bogos binted")
//                    .foregroundColor(Color.black)
//                    .padding()
//                    .frame(width: 300)
//                    .background(Color.white)
//                    .cornerRadius(25)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 25)
//                            .stroke(Color.black, lineWidth: 1)
//                    )
//            }
////            .disabled(files.isEmpty)
//            .padding(.bottom, 100)
//        }
//        .onChange(of: files.count) {
//            files = Array(Set(files))
//            selectedIndex = files.count - 1
//        }
//    }
//    
//    private func handleFileSelection(result: Result<[URL], Error>) {
//        switch result {
//        case .success(let urls):
//            for url in urls {
//                do {
//                    let fileSize = try url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
//                    let fileSizeInMB = Double(fileSize) / (1024 * 1024)
//                    if fileSizeInMB <= 5 {
//                        let file = File(uploaded: false, fileURL: url.absoluteString, fileType: url.pathExtension.lowercased())
//                        files.append(file)
//                        print("File selected: \(url)")
//                    } else {
//                        print("File size exceeds 5MB limit")                    }
//                } catch {
//                    print("Failed to retrieve file size: \(error.localizedDescription)")
//                }
//            }
//        case .failure(let error):
//            print("Failed to select file: \(error.localizedDescription)")
//            // Show an alert or user message about the failure
//        }
//    }
//}
//
//struct PDFPreviewView: UIViewRepresentable {
//    var url: URL
//    
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView(frame: .zero)
//        
//        // Create a PDF document from the URL
//        guard let pdfDocument = PDFDocument(url: url) else {
//            return view
//        }
//        
//        // Get the first page of the PDF
//        guard let pdfPage = pdfDocument.page(at: 0) else {
//            return view
//        }
//        
//        // Create a PDF page view
//        let pdfPageView = PDFPageView(page: pdfPage)
//        pdfPageView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(pdfPageView)
//        
//        // Add constraints to center the PDF page view
//        NSLayoutConstraint.activate([
//            pdfPageView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            pdfPageView.heightAnchor.constraint(equalTo: view.heightAnchor),
//            pdfPageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            pdfPageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//        
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {
//        // No update needed
//    }
//}
//
//class PDFPageView: UIView {
//    var page: PDFPage
//    
//    init(page: PDFPage) {
//        self.page = page
//        super.init(frame: .zero)
//        self.backgroundColor = .white
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        context.saveGState()
//        
//        // Fill the background color
//        UIColor.white.setFill()
//        context.fill(rect)
//        
//        // Render the PDF page
//        let pdfRect = self.page.bounds(for: .mediaBox)
//        let scale = min(rect.width / pdfRect.width, rect.height / pdfRect.height)
//        context.scaleBy(x: scale, y: scale)
//        context.translateBy(x: 0, y: pdfRect.height)
//        context.scaleBy(x: 1, y: -1)
//        
//        self.page.draw(with: .mediaBox, to: context)
//        
//        context.restoreGState()
//    }
//}
//
//@MainActor func uploadFiles() {
//    for index in backendCapsule.miscFiles.indices where !backendCapsule.miscFiles[index].uploaded {
//        
//        CapsuleAPIClient.shared.upload(
//        authorization: jwt,
//        fileURL:  URL(string: backendCapsule.miscFiles[index].fileURL)!,
//        fileType: backendCapsule.miscFiles[index].fileType)
//        { result in
//            switch result {
//                
//                case .success(let result):
//                    
//                    let body: [String: Any] =
//                        ["authorization": jwt,
//                        "capsuleID": backendCapsule.capsule.id,
//                        "objectName": result.objectName,
//                        "fileURL": result.fileURL]
//                    
//                    CapsuleAPIClient.shared.create(
//                    authorization: jwt,
//                    mediaType: .miscFile,
//                    body: body)
//                    { result in
//                        switch result {
//                            
//                        case .success(let result):
//                            print("Uploaded")
//                            backendCapsule.miscFiles[index].id = result.id
//                            backendCapsule.miscFiles[index].uploaded = true
//                            
//                        case .failure(let error):
//                            print(error)
//                            
//                        }
//                    }
//                    
//                case .failure(let error):
//                    print(error)
//                    
//            }
//        }
//    }
//}
//
//#Preview {
//    ZStack {
//        BackgroundImageView()
//        AddFile(AGstate: .constant(""))
//            .environmentObject(Capsule())
//    }
//}
