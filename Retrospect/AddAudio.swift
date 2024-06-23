//
//  AddAudio.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-22.
//

import SwiftUI
import AVFoundation

struct AddAudio: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isRecording = false
    @State private var audioURL: URL?
    @State private var showDocumentPicker = false

    var body: some View {
        VStack {
            Text("Add Audio")
                .font(.largeTitle)
                .padding()

            List {
                ForEach(dataStore.audios.indices, id: \.self) { index in
                    VStack {
                        Text("Audio \(index + 1)")
                        Button(action: {
                            playAudio(data: dataStore.audios[index])
                        }) {
                            Text("Play Audio \(index + 1)")
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }

            HStack {
                Button(action: recordAudio) {
                    Text(isRecording ? "Stop Recording" : "Record Audio")
                        .padding()
                        .background(isRecording ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Button(action: { showDocumentPicker = true }) {
                    Text("Upload from Voice Memos")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }

            Spacer()
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker(audioURL: $audioURL)
                .environmentObject(dataStore)
        }
    }

    func recordAudio() {
        if isRecording {
            audioRecorder?.stop()
            isRecording = false
            if let url = audioRecorder?.url {
                if let data = try? Data(contentsOf: url) {
                    dataStore.audios.append(data)
                }
                audioURL = url
            }
        } else {
            startRecording()
        }
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            // Handle the error
            print("Failed to start recording: \(error)")
        }
    }

    func playAudio(data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.play()
        } catch {
            print("Failed to play audio: \(error)")
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var audioURL: URL?
    @EnvironmentObject var dataStore: DataStore

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                parent.audioURL = url
                if let data = try? Data(contentsOf: url) {
                    parent.dataStore.audios.append(data)
                }
            }
        }
    }
}

#Preview {
    AddAudio()
        .environmentObject(DataStore())
}
