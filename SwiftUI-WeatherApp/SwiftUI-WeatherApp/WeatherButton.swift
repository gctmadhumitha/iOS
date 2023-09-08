//
//  WeatherButton.swift
//  SwiftUI-WeatherApp
//
//  Created by Madhumitha Loganathan on 08/09/23.
//

import SwiftUI

struct WeatherButton: View {
    
    let title: String
    var textColor : Color
    var backgroundColor: Color
    var body : some View {
        Text(title)
        .frame(width: 280, height:50)
        .background(backgroundColor.gradient) // for subtle gradient
        .foregroundColor(textColor)
        .font(.system(size:20, weight:.bold, design: .default))
        .cornerRadius(10)
    }
}
