//
//  ColorPickerView.swift
//  SwiftUI-DrawingApp
//
//  Created by Madhumitha Loganathan on 20/09/23.
//

import Foundation
import SwiftUI

struct ColorPickerView : View {
    
    let colors = [Color.red, Color.green, Color.purple, Color.cyan, Color.orange, Color.blue, Color.yellow]
    @Binding var selectedColor : Color
    
    
    var body : some View {
        HStack {
            ForEach( colors, id : \.self) { color in
                Image(systemName:  selectedColor == color ? "circle" : "record.circle.fill")
                    .foregroundColor(color)
                    .clipShape(Circle())
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
        
        
    }
    
}
