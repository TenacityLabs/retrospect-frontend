//
//  AudioRecording.swift
//  Retrospect
//
//  Created by John Liu on 2024-07-05.
//

import SwiftUI
import AVFoundation
import Accelerate

import SwiftUI
import AVFoundation
import Accelerate

struct WaveformView: View {
    @StateObject private var audioRecorder = AudioRecorder()

    var body: some View {
        VStack {
            Waveform(audioSamples: audioRecorder.audioSamples)
                .stroke(lineWidth: 1)
                .foregroundColor(.blue)
                .padding()
            
            HStack {
                Button(action: {
                    if audioRecorder.isRecording {
                        audioRecorder.stopRecording()
                    } else {
                        audioRecorder.startRecording()
                    }
                }) {
                    Text(audioRecorder.isRecording ? "Stop" : "Record")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

struct Waveform: Shape {
    var audioSamples: [Float]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midY = rect.height / 2
        let step = rect.width / CGFloat(audioSamples.count)
        
        path.move(to: CGPoint(x: 0, y: midY))
        
        for (index, sample) in audioSamples.enumerated() {
            let x = CGFloat(index) * step
            let y = midY - CGFloat(sample) * midY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
}

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private let audioEngine = AVAudioEngine()
    
    @Published var isRecording = false
    @Published var audioSamples: [Float] = []
    
    func startRecording() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
        ] as [String : Any]
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
            
            let url = URL(fileURLWithPath: "/dev/null")
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            
            isRecording = true
            startTimer()
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
        stopTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.updateMeters()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateMeters() {
        audioRecorder?.updateMeters()
        
        if let audioRecorder = audioRecorder {
            let averagePower = audioRecorder.averagePower(forChannel: 0)
            let linearLevel = pow(10, averagePower / 20)
            audioSamples.append(Float(linearLevel))
            
            if audioSamples.count > 1000 {
                audioSamples.removeFirst()
            }
        }
    }
}

struct WaveformView_Previews: PreviewProvider {
    static var previews: some View {
        WaveformView()
    }
}
