//
//  ContentView.swift
//  SwiftUI-DrawingApp
//
//  Created by Madhumitha Loganathan on 20/09/23.
//

import SwiftUI

struct Line {
    var points = [CGPoint]()
    var color: Color = .red
    var lineWidth: Double = 1.0
}

struct ContentView: View {
    
    @State private var currentLine = Line()
    @State private var lines: [Line] = [Line]()
    
    var body: some View {
        VStack {
            Canvas { context, size  in
                for line in lines {
                    var path = Path()
                    path.addLines(line.points)
                    context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
                    
                }
                
            }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged({ value in
                    print("onChanged")
                    let newPoint = value.location
                    currentLine.points.append(newPoint)
                    self.lines.append(currentLine)
                    
                })
                .onEnded({ value in
                    print("onEnded")
                    
                    self.currentLine = Line(points:[], color: currentLine.color, lineWidth: currentLine.lineWidth)
                })
            )
            HStack {
                Slider(value:$currentLine.lineWidth, in : 1...20){
                    Text("Line Width")
                }.frame(maxWidth: 200)
                .onChange(of: currentLine.lineWidth) { newValue in
                    currentLine.lineWidth = newValue
                }
                Spacer()
                ColorPickerView(selectedColor: $currentLine.color)
                    .onChange(of: currentLine.color) { newColor in
                        currentLine.color = newColor
                    }
            }.padding()
        }
        .frame(minWidth: 400, minHeight: 400)
       
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
