//
//  CreateDrawing.swift
//  Retrospect
//
//  Created by Andrew Durnford on 2024-06-22.
//

import SwiftUI
import UIKit

struct PathWithColor {
    var path: UIBezierPath
    var color: UIColor
}

class DrawingView: UIView {
    
    private var currentPath = UIBezierPath()
    private var startPoint: CGPoint?
    private var touchPoint: CGPoint?
    private var paths: [PathWithColor] = []
    var strokeColor: UIColor = .black
    var strokeWidth: CGFloat = 2.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.isMultipleTouchEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        startPoint = touch.location(in: self)
        currentPath = UIBezierPath()
        currentPath.lineWidth = strokeWidth
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchPoint = touch.location(in: self)
        
        if let startPoint = startPoint, let touchPoint = touchPoint {
            currentPath.move(to: startPoint)
            currentPath.addLine(to: touchPoint)
            self.startPoint = touchPoint
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let startPoint = startPoint, let touchPoint = touchPoint {
            currentPath.move(to: startPoint)
            currentPath.addLine(to: touchPoint)
        }
        paths.append(PathWithColor(path: currentPath, color: strokeColor))
        startPoint = nil
        touchPoint = nil
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        for pathWithColor in paths {
            pathWithColor.color.setStroke()
            pathWithColor.path.stroke()
        }
        strokeColor.setStroke()
        currentPath.stroke()
    }
    
    func clear() {
        paths.removeAll()
        setNeedsDisplay()
    }
}

struct DrawingViewRepresentable: UIViewRepresentable {
    @Binding var clear: Bool
    @Binding var color: Color
    @Binding var strokeWidth: CGFloat
    
    func makeUIView(context: Context) -> DrawingView {
        return DrawingView()
    }
    
    func updateUIView(_ uiView: DrawingView, context: Context) {
        if clear {
            uiView.clear()
            clear = false
        }
        uiView.strokeColor = UIColor(color)
        uiView.strokeWidth = strokeWidth
    }
}

struct CreateDrawing: View {
    @State private var clear = false
    @State private var color = Color.black
    @State private var strokeWidth: CGFloat = 2.0

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Drawing Page")
                    .font(.largeTitle)
                    .padding()

                DrawingViewRepresentable(clear: $clear, color: $color, strokeWidth: $strokeWidth)
                    .frame(height: geometry.size.height / 2)
                    .border(Color.gray.opacity(0.25), width: 1)

                VStack {
                    ColorPicker("Select Color", selection: $color)
                    
                    HStack {
                        Text("Stroke Width")
                        Slider(value: $strokeWidth, in: 1...20, step: 1)
                            .padding()
                    }
                }.padding()

                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        clear = true
                    }) {
                        Text("Clear")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
}

struct CreateDrawing_Previews: PreviewProvider {
    static var previews: some View {
        CreateDrawing()
    }
}
