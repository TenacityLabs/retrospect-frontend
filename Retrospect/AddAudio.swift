//import SwiftUI
//import AVFoundation
//
//struct AddAudio: View {
//    @EnvironmentObject var globalState: GlobalState
//    @State private var audioRecorder: AVAudioRecorder?
//    @State private var audioPlayer: AVAudioPlayer?
//    @State private var isRecording = false
//    @State private var audioURL: URL?
//    @State private var showDocumentPicker = false
//    @State private var levels: [CGFloat] = []
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Add Audio")
//                .font(.largeTitle)
//                .padding()
//
//            WaveformView(levels: $levels)
//                .frame(height: 50)
//                .padding([.leading, .trailing])
//
//            HStack(spacing: 20) {
//                Button(action: recordAudio) {
//                    Text(isRecording ? "Stop Recording" : "Record Audio")
//                        .padding()
//                        .frame(width: 150)
//                        .background(isRecording ? Color.red : Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding()
//
//                Button(action: { showDocumentPicker = true }) {
//                    Text("Upload from Voice Memos")
//                        .padding()
//                        .frame(width: 200)
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding()
//            }
//
//            Button(action: {
//                AGstate = "AdditionalGoodies"
//            }) {
//                Text("I'm Done!")
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(width: 300)
//                    .background(Color.gray)
//                    .cornerRadius(25)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 25)
//                            .stroke(Color.black, lineWidth: 1)
//                    )
//            }
//            .padding(.horizontal, 20)
//
//            List {
//                ForEach(localCapsule.audios.indices, id: \.self) { index in
//                    VStack {
//                        Text("Audio \(index + 1)")
//                        WaveformView(levels: .constant(self.generateWaveform(from: localCapsule.audios[index])))
//                            .frame(height: 50)
//                            .padding([.leading, .trailing])
//                        Button(action: {
//                            playAudio(data: localCapsule.audios[index])
//                        }) {
//                            Text("Play Audio \(index + 1)")
//                                .padding()
//                                .background(Color.orange)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                        }
//                        .padding()
//                    }
//                }
//            }
//        }
//        .sheet(isPresented: $showDocumentPicker) {
//            DocumentPicker(audioURL: $audioURL)
//                .environmentObject(localCapsule)
//        }
//        .onAppear(perform: setupAudioSession)
//    }
//
//    func setupAudioSession() {
//        do {
//            let audioSession = AVAudioSession.sharedInstance()
//            try audioSession.setCategory(.playAndRecord, mode: .default)
//            try audioSession.setActive(true)
//            audioSession.requestRecordPermission { granted in
//                if !granted {
//                    print("Permission to record not granted")
//                }
//            }
//        } catch {
//            print("Failed to set up audio session: \(error)")
//        }
//    }
//
//    func recordAudio() {
//        if isRecording {
//            audioRecorder?.stop()
//            isRecording = false
//            if let url = audioRecorder?.url {
//                DispatchQueue.global().async {
//                    if let data = try? Data(contentsOf: url) {
//                        DispatchQueue.main.async {
//                            self.localCapsule.audios.append(data)
//                        }
//                    }
//                    DispatchQueue.main.async {
//                        self.audioURL = url
//                    }
//                }
//            }
//        } else {
//            startRecording()
//        }
//    }
//
//    func startRecording() {
//        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
//
//        let settings = [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//            AVSampleRateKey: 12000,
//            AVNumberOfChannelsKey: 1,
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//        ]
//
//        do {
//            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
//            audioRecorder?.isMeteringEnabled = true
//            audioRecorder?.record()
//            isRecording = true
//
//            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
//                guard let audioRecorder = self.audioRecorder else { return }
//                if self.isRecording {
//                    audioRecorder.updateMeters()
//                    let level = self.normalizeSoundLevel(level: audioRecorder.averagePower(forChannel: 0))
//                    self.levels.append(level)
//                    if self.levels.count > Int(10 / 0.05) { // ensure we have at least 10 seconds of data
//                        self.levels.removeFirst()
//                    }
//                } else {
//                    timer.invalidate()
//                }
//            }
//        } catch {
//            // Handle the error
//            print("Failed to start recording: \(error)")
//        }
//    }
//
//    func playAudio(data: Data) {
//        do {
//            audioPlayer = try AVAudioPlayer(data: data)
//            audioPlayer?.play()
//        } catch {
//            print("Failed to play audio: \(error)")
//        }
//    }
//
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//
//    func normalizeSoundLevel(level: Float) -> CGFloat {
//        let level = max(0.2, CGFloat(level + 50) / 50) // adjust the range of sound level
//        return CGFloat(level)
//    }
//
//    func generateWaveform(from data: Data) -> [CGFloat] {
//        guard let audioPlayer = try? AVAudioPlayer(data: data) else { return [] }
//        audioPlayer.isMeteringEnabled = true
//        var levels: [CGFloat] = []
//        
//        audioPlayer.play()
//        
//        let sampleRate = audioPlayer.format.sampleRate
//        let samplesPerSecond = Int(sampleRate / 10) // ten samples per second
//
//        while audioPlayer.isPlaying {
//            audioPlayer.updateMeters()
//            let level = normalizeSoundLevel(level: audioPlayer.averagePower(forChannel: 0))
//            levels.append(level)
//            usleep(useconds_t(1_000_000 / samplesPerSecond))
//        }
//        
//        return levels
//    }
//}
//
//struct Record: View {
//    
//    var body: some View {
//        GeometryReader { geometry in
//            VStack {
//                Spacer()
//                VStack {
//                    Text("Record \n Something")
//                        .font(.custom("IvyOraDisplay-Regular", size: 48))
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(.white)
//                        .padding(.top, 80)
//                    
//                    
//                    VStack {
//                        Image(systemName: "mic.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .foregroundColor(.white)
//                            .frame(height: 80)
//                        
//                        Text("Make a Recording")
//                            .font(.custom("Syne-Regular", size: 24))
//                            .padding(.top, 10)
//                            .foregroundColor(.white)
//                    }
//                    .padding()
//                    .frame(width: (geometry.size.width - 60), height: 180)
//                    .background(Color(red: 44/255, green: 44/255, blue: 44/255).opacity(0.9))
//                    .cornerRadius(20)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 20)
//                            .inset(by: 0.5)
//                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
//                    )
//                    
//                    Spacer()
//                        .frame(height: 10)
//                    
//                    VStack {
//                        Image(systemName: "waveform")
//                            .resizable()
//                            .scaledToFit()
//                            .foregroundColor(.white)
//                            .frame(height: 80)
//                        
//                        Text("Upload from Voice Memos")
//                            .font(.custom("Syne-Regular", size: 24))
//                            .padding(.top, 10)
//                            .foregroundColor(.white)
//                    }
//                    .padding()
//                    .frame(width: (geometry.size.width - 60), height: 180)
//                    .background(Color(red: 44/255, green: 44/255, blue: 44/255).opacity(0.9))
//                    .cornerRadius(20)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 20)
//                            .inset(by: 0.5)
//                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
//                    )
//                    Spacer()
//                }
//                Spacer()
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//    }
//}
//
//
//struct WaveformView: View {
//    @Binding var levels: [CGFloat]
//
//    var body: some View {
//        GeometryReader { geometry in
//            let height = geometry.size.height
//            let width = geometry.size.width / CGFloat(max(levels.count, 1))
//            HStack(spacing: 1) {
//                ForEach(levels, id: \.self) { level in
//                    Rectangle()
//                        .fill(Color.blue)
//                        .frame(width: width, height: height * level)
//                }
//            }
//        }
//    }
//}
//
//struct DocumentPicker: UIViewControllerRepresentable {
//    @Binding var audioURL: URL?
//    @EnvironmentObject var localCapsule: Capsule
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
//        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
//
//    class Coordinator: NSObject, UIDocumentPickerDelegate {
//        var parent: DocumentPicker
//
//        init(_ parent: DocumentPicker) {
//            self.parent = parent
//        }
//
//        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//            if let url = urls.first {
//                self.parent.audioURL = url
//                DispatchQueue.global().async {
//                    if let data = try? Data(contentsOf: url) {
//                        DispatchQueue.main.async {
//                            self.parent.localCapsule.audios.append(data)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//#Preview {
////    AddAudio(AGstate: .constant(""))
////        .environmentObject(Capsule())
//    ZStack {
//        BackgroundImageView()
//        Record()
//    }
//}
