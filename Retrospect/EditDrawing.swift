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
    var paths: [PathWithColor] = [] {
        didSet {
            setNeedsDisplay()
            delegate?.didUpdatePaths(paths)
        }
    }
    
    weak var delegate: DrawingViewDelegate?
    
    private var currentPath = UIBezierPath()
    private var points: [CGPoint] = []
    var strokeColor: UIColor = .black
    var strokeWidth: CGFloat = 2.0
    var isEditable: Bool = true
    
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
        guard isEditable, let touch = touches.first else { return }
        let startPoint = touch.location(in: self)
        points = [startPoint]
        currentPath = UIBezierPath()
        currentPath.lineWidth = strokeWidth
        addCircle(at: startPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEditable, let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        
        if let lastPoint = points.last {
            let distance = hypot(touchPoint.x - lastPoint.x, touchPoint.y - lastPoint.y)
            let numberOfSteps = Int(distance / strokeWidth) + 1
            for i in 1..<numberOfSteps {
                let interpolatedPoint = interpolate(from: lastPoint, to: touchPoint, with: CGFloat(i) / CGFloat(numberOfSteps))
                addCircle(at: interpolatedPoint)
            }
        }
        
        points.append(touchPoint)
        addCircle(at: touchPoint)
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEditable else { return }
        for point in points {
            addCircle(at: point)
        }
        paths.append(PathWithColor(path: currentPath, color: strokeColor))
        points.removeAll()
        setNeedsDisplay()
    }
    
    private func addCircle(at point: CGPoint) {
        let circlePath = UIBezierPath(arcCenter: point, radius: strokeWidth / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        currentPath.append(circlePath)
    }
    
    private func interpolate(from: CGPoint, to: CGPoint, with factor: CGFloat) -> CGPoint {
        let x = from.x + (to.x - from.x) * factor
        let y = from.y + (to.y - from.y) * factor
        return CGPoint(x: x, y: y)
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
        currentPath = UIBezierPath()
        setNeedsDisplay()
    }
}

protocol DrawingViewDelegate: AnyObject {
    func didUpdatePaths(_ paths: [PathWithColor])
}

struct DrawingViewRepresentable: UIViewRepresentable {
    @Binding var clear: Bool
    @Binding var color: Color
    @Binding var strokeWidth: CGFloat
    @Binding var paths: [PathWithColor]
    var isEditable: Bool

    class Coordinator: NSObject, DrawingViewDelegate {
        var parent: DrawingViewRepresentable

        init(parent: DrawingViewRepresentable) {
            self.parent = parent
        }

        func didUpdatePaths(_ paths: [PathWithColor]) {
            DispatchQueue.main.async {
                self.parent.paths = paths
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> DrawingView {
        let drawingView = DrawingView()
        drawingView.delegate = context.coordinator
        drawingView.isEditable = isEditable
        return drawingView
    }

    func updateUIView(_ uiView: DrawingView, context: Context) {
        if clear {
            uiView.clear()
            DispatchQueue.main.async {
                self.paths = [] // Clear the paths
                self.clear = false
            }
        } else {
            uiView.paths = paths
        }
        uiView.strokeColor = UIColor(color)
        uiView.strokeWidth = strokeWidth
        uiView.isEditable = isEditable
    }
}

struct EditDrawing: View {
    @EnvironmentObject var dataStore: Capsule
    @State private var clear = false
    @State private var color = Color.black
    @State private var strokeWidth: CGFloat = 2.0
    @Binding var AGstate: String
    @Binding var drawIndex: Int

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Drawing Page")
                    .font(.largeTitle)
                    .padding()

                DrawingViewRepresentable(
                    clear: $clear,
                    color: $color,
                    strokeWidth: $strokeWidth,
                    paths: $dataStore.drawings[drawIndex],
                    isEditable: true
                )
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

                Button(action: {
                    AGstate = "CreateDrawing"
                }) {
                    Text("Done")
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
            }
            .padding()
        }
    }
}

#Preview {
    EditDrawing(AGstate: .constant(""), drawIndex: .constant(0))
        .environmentObject(Capsule())
}
