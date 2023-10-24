//
//  Colors.swift
//  iQuest
//
//  Created by Madhumitha Loganathan on 08/09/23.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
    
    /// The SwiftUI color associated with the receiver.
    var suColor: Color { Color(self) }
    
    static var random: UIColor {
            let redValue = CGFloat(drand48())
            let greenValue = CGFloat(drand48())
            let blueValue = CGFloat(drand48())
                
            let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
                
            return randomColor
    }
}


