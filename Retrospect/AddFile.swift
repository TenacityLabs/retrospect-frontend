import SwiftUI
import UniformTypeIdentifiers
import PDFKit

struct AddFile: View {
    @EnvironmentObject var dataStore: capsule
    @State private var isDocumentPickerPresented = false
    @Binding var AGstate: String
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        VStack {
            Text(dataStore.files.isEmpty ? "Add Files" : "These look great!")
                .font(.largeTitle)
                .padding(.top, 100)
                .foregroundColor(.white)
            Spacer()
            
            TabView(selection: $selectedIndex) {
                ForEach(dataStore.files.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack {
                            PDFPreviewView(url: dataStore.files[index])
                                .frame(maxHeight: 300)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }
                    .padding(.horizontal, 20)
                    .tag(index)
                }
                if dataStore.files.count < 9 {
                    Button(action: {
                        isDocumentPickerPresented = true
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .frame(width: 150, height: 150)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(15)
                    }
                    .tag(dataStore.files.count)
                    .fileImporter(
                        isPresented: $isDocumentPickerPresented,
                        allowedContentTypes: [.pdf],
                        allowsMultipleSelection: true // Allow multiple selection
                    ) { result in
                        isDocumentPickerPresented = false
                        handleFileSelection(result: result)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)

            HStack {
                ForEach(0..<dataStore.files.count + (dataStore.files.count < 9 ? 1 : 0), id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.white : Color.white.opacity(0.1))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: selectedIndex)
                }
            }
            .padding(.top, 10)
            Spacer()

            Button(action: {
                AGstate = "AdditionalGoodies"
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
//            .disabled(dataStore.files.isEmpty)
            .padding(.bottom, 100)
        }
        .onChange(of: dataStore.files.count) {
            dataStore.files = Array(Set(dataStore.files))
            selectedIndex = dataStore.files.count - 1
        }
    }
    
    private func handleFileSelection(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            for url in urls {
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

struct PDFPreviewView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        // Create a PDF document from the URL
        guard let pdfDocument = PDFDocument(url: url) else {
            return view
        }
        
        // Get the first page of the PDF
        guard let pdfPage = pdfDocument.page(at: 0) else {
            return view
        }
        
        // Create a PDF page view
        let pdfPageView = PDFPageView(page: pdfPage)
        pdfPageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfPageView)
        
        // Add constraints to center the PDF page view
        NSLayoutConstraint.activate([
            pdfPageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            pdfPageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            pdfPageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pdfPageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // No update needed
    }
}

class PDFPageView: UIView {
    var page: PDFPage
    
    init(page: PDFPage) {
        self.page = page
        super.init(frame: .zero)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        
        // Fill the background color
        UIColor.white.setFill()
        context.fill(rect)
        
        // Render the PDF page
        let pdfRect = self.page.bounds(for: .mediaBox)
        let scale = min(rect.width / pdfRect.width, rect.height / pdfRect.height)
        context.scaleBy(x: scale, y: scale)
        context.translateBy(x: 0, y: pdfRect.height)
        context.scaleBy(x: 1, y: -1)
        
        self.page.draw(with: .mediaBox, to: context)
        
        context.restoreGState()
    }
}

#Preview {
    ZStack {
        BackgroundImageView()
        AddFile(AGstate: .constant(""))
            .environmentObject(capsule())
    }
}
